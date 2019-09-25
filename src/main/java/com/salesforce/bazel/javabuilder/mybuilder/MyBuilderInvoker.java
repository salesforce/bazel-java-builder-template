package com.salesforce.bazel.javabuilder.mybuilder;

import com.salesforce.bazel.javabuilder.worker.GenericWorker;
import com.salesforce.bazel.javabuilder.worker.Processor;

import picocli.CommandLine;
import picocli.CommandLine.ParameterException;
import picocli.CommandLine.ParseResult;

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
            MyBuilderCommand command = new MyBuilderCommand();
            try {
                ParseResult parseResult = new CommandLine(command).parseArgs(args);
                if (!CommandLine.printHelpIfRequested(parseResult)) {
                    Integer result = command.call();
                    return result != null ? result.intValue() : 0;
                }
            } catch (ParameterException ex) { // command line arguments could not be parsed
                System.err.println(ex.getMessage());
                ex.getCommandLine().usage(System.err);
            }
            return 1;
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
