/*-
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
 * Derived from:
 *   https://github.com/bazelbuild/rules_scala/blob/master/src/java/io/bazel/rulesscala/worker/GenericWorker.java
 */
package com.salesforce.bazel.javabuilder.worker;

import static java.nio.charset.StandardCharsets.UTF_8;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

import org.slf4j.bridge.SLF4JBridgeHandler;

import com.google.devtools.build.lib.worker.WorkerProtocol.WorkRequest;
import com.google.devtools.build.lib.worker.WorkerProtocol.WorkResponse;
import com.google.protobuf.ProtocolStringList;

/**
 * This class serves as a helper to either run a builder as a one-off command or as a persistent worker for Bazel.
 * <p>
 * The one-off case supports a trick to allow passing a very long list of arguments as a file. See
 * {@link #normalize(List)} for how this works.
 * </p>
 */
public class GenericWorker {

    public static <T> String[] appendToString(String[] init, List<T> rest) {
        String[] tmp = new String[init.length + rest.size()];
        System.arraycopy(init, 0, tmp, 0, init.length);
        int baseIdx = init.length;
        for (T t : rest) {
            tmp[baseIdx] = t.toString();
            baseIdx += 1;
        }
        return tmp;
    }

    public static String[] merge(String[]... arrays) {
        int totalLength = 0;
        for (String[] arr : arrays) {
            totalLength += arr.length;
        }

        String[] result = new String[totalLength];
        int offset = 0;
        for (String[] arr : arrays) {
            System.arraycopy(arr, 0, result, offset, arr.length);
            offset += arr.length;
        }
        return result;
    }

    private static String[] normalize(String[] args) throws IOException {
        if ((args.length == 1) && args[0].startsWith("@")) {
            List<String> lines = Files.readAllLines(Paths.get(args[0].substring(1)), UTF_8);
            return lines.toArray(new String[lines.size()]);
        } else
            return args;
    }

    protected final Processor processor;

    public GenericWorker(Processor p) {
        processor = p;
    }

    private boolean contains(String[] args, String s) {
        for (String str : args) {
            if (str.equals(s))
                return true;
        }
        return false;
    }

    /** This is expected to be called by a main method */
    public void run(String[] args) throws Exception {
        // prepare logging
        SLF4JBridgeHandler.removeHandlersForRootLogger();
        SLF4JBridgeHandler.install();

        // run
        if (contains(args, "--persistent_worker")) {
            runPersistentWorker();
        } else {
            int exitCode = processor.processRequest(normalize(args));
            System.exit(exitCode);
        }
    }

    // Mostly lifted from Bazel
    private void runPersistentWorker() throws IOException {
        PrintStream originalStdOut = System.out;
        PrintStream originalStdErr = System.err;

        while (true) {
            try {
                WorkRequest request = WorkRequest.parseDelimitedFrom(System.in);
                if (request == null) {
                    break;
                }
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                int exitCode = 0;

                try (PrintStream ps = new PrintStream(baos)) {
                    setupOutput(ps);

                    try {
                        ProtocolStringList argumentsList = request.getArgumentsList();
                        exitCode = processor.processRequest(argumentsList.toArray(new String[argumentsList.size()]));
                    } catch (Throwable e) {
                        e.printStackTrace();
                        exitCode = 1;
                    }
                } finally {
                    System.setOut(originalStdOut);
                    System.setErr(originalStdErr);
                }

                WorkResponse.newBuilder().setOutput(baos.toString()).setExitCode(exitCode).build().writeDelimitedTo(System.out);
                System.out.flush();
            } finally {
                System.gc();
            }
        }
    }

    protected void setupOutput(PrintStream ps) {
        System.setOut(ps);
        System.setErr(ps);
    }
}
