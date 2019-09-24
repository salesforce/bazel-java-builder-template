package com.salesforce.bazel.javabuilder.mybuilder;

import picocli.CommandLine;
import picocli.CommandLine.Command;
import picocli.CommandLine.Option;

import java.io.*;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.Callable;

import static java.nio.file.Files.newBufferedWriter;
import java.nio.file.Path;

@Command(name="builder-template", description = "builder template")
public class MyBuilderProcessor implements Callable<Void> {

	@Option(names = { "-o", "--outputFile" }, description = "The Output File")
    private String outputFile;

    @Option(names = { "-i", "--inputFile" }, description = "The Input File")
    private String inputFile;

    public static void main(String[] args) throws IOException {
        CommandLine.call(new MyBuilderProcessor(), args);
    }

    @Override
    public Void call() throws Exception {
    	MyBuilderProcessor mybuilder = new MyBuilderProcessor();
    	mybuilder.copyToFile(inputFile, outputFile);
    	return null;
    }

    private static void copyToFile(String filePath, String outputFileName)
            throws java.io.IOException {

        Path outputFilePath = java.nio.file.Paths.get(outputFileName);
        try (
                BufferedReader br = new BufferedReader(new FileReader(filePath));
                BufferedWriter writer = newBufferedWriter(outputFilePath)
        ) {
            String info;
            while ((info = br.readLine()) != null) {
                writer.write(info + "\n");
            }
        }
    }

}
