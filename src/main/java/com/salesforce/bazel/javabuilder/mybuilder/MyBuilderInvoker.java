package com.salesforce.bazel.javabuilder.mybuilder;

import com.salesforce.bazel.javabuilder.worker.GenericWorker;
import com.salesforce.bazel.javabuilder.worker.Processor;

import picocli.CommandLine;

/**
 * Main entry point for MyBuilder.
 * <p>
 * It delegates to {@link GenericWorker} for turning the builder into a persistent worker if necessary.
 * Builder implementors should provide commands (eg., {@link MyBuilderCommand}) suitable for running the builder.
 * <a href="https://picocli.info/">Picocli</a> is used in the default {@link Processor} implementation.
 * </p>
 */
public class MyBuilderInvoker extends GenericWorker {

    public static class MyBuilderProcessor implements Processor {

        @Override
        public int processRequest(String[] args) throws Exception {
            return new CommandLine(new MyBuilderCommand()).execute(args);
        }
    }

    public static void main(String[] args) {
        try {
            GenericWorker w = new MyBuilderInvoker();
            w.run(args);
        } catch (Exception ex) {
            ex.printStackTrace();
            System.exit(1);
        }
    }

    public MyBuilderInvoker() {
        super(new MyBuilderProcessor());
    }

}
