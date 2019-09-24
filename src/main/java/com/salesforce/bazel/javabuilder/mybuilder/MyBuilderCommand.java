package com.salesforce.bazel.javabuilder.mybuilder;

import static java.nio.file.Files.newBufferedWriter;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.nio.file.Path;
import java.util.concurrent.Callable;

import picocli.CommandLine.Command;
import picocli.CommandLine.Option;

@Command(name = "mybuilder", description = "A sample builder which generates a file")
public class MyBuilderCommand implements Callable<Void> {

    private static void copyToFile(String filePath, String outputFileName) throws java.io.IOException {

        Path outputFilePath = java.nio.file.Paths.get(outputFileName);
        try (BufferedReader br = new BufferedReader(new FileReader(filePath)); BufferedWriter writer = newBufferedWriter(outputFilePath)) {
            String info;
            while ((info = br.readLine()) != null) {
                writer.write(info + "\n");
            }
        }
    }

    @Option(names = {"-o", "--outputFile"}, description = "The Output File")
    private String outputFile;

    @Option(names = {"-i", "--inputFile"}, description = "The Input File")
    private String inputFile;

    @Override
    public Void call() throws Exception {
        copyToFile(inputFile, outputFile);
        return null;
    }

}
