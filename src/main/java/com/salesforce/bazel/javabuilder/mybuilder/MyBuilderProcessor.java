package com.salesforce.bazel.javabuilder.mybuilder;

import picocli.CommandLine;
import picocli.CommandLine.Command;
import picocli.CommandLine.Option;

import java.io.*;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.Callable;

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
    	//inputs to be processed here
    	mybuilder.copyToFile(inputFile, outputFile);
    	return null;
    }

    private Set<String> getInformationFromFile(String filePath) throws IOException {
        File file = new File(filePath);
        BufferedReader br = new BufferedReader(new FileReader(file));

        Set<String> information = new HashSet<>();
        String info;
        while ((info = br.readLine()) != null) {
            information.add(info);
        }
        return information;
    }

    private void copyToFile(String inputFile, String outputFile) throws Exception {
    	BufferedWriter writer = new BufferedWriter(new FileWriter(outputFile));

    	Set<String> inputs = getInformationFromFile(inputFile);

    	for(String str:inputs) {
    		writer.write(str + "\n");
    	}
     
    	writer.close();

    }

}
