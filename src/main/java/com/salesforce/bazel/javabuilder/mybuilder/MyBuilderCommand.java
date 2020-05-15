package com.salesforce.bazel.javabuilder.mybuilder;

import static java.lang.String.format;
import static java.nio.file.Files.createDirectories;
import static java.nio.file.Files.isDirectory;
import static java.nio.file.Files.size;
import static java.nio.file.Files.write;
import static java.nio.file.Paths.get;

import java.io.IOException;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;

import com.google.common.base.CaseFormat;
import com.google.common.base.CharMatcher;

import picocli.CommandLine.Command;
import picocli.CommandLine.Option;

import org.apache.commons.text.StringEscapeUtils;

@Command(name = "mybuilder", description = "A sample builder which generates a file")
public class MyBuilderCommand implements Callable<Integer> {

    @Option(names = {"-o", "--output"}, description = "output directory")
    private Path outputDirectory;

    @Option(names = {"-i", "--input"}, description = "input files", split = ",")
    private List<Path> inputFiles;

    @Option(names = {"--current-target"}, description = "target name")
    private String currentTarget;

    @Override
    public Integer call() throws Exception {
        String packageName = currentTarget.toLowerCase();
        String className = CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.UPPER_CAMEL, CharMatcher.is('-').replaceFrom(currentTarget, '_'));

        List<String> lines = new ArrayList<>();
        lines.add(format("package %s;", packageName));
        lines.add("");
        lines.add(format("public class %s {", className));
        lines.add("");
        lines.add(format("    // user.dir: %s", System.getProperty("user.dir")));
        lines.add(format("    //      '.': %s", get(".").toAbsolutePath().normalize()));
        lines.add("");
        lines.add(format("    //   output: %s", outputDirectory));
        lines.add(format("    //           %s (normalized)", outputDirectory.toAbsolutePath().normalize()));
        lines.add("");
        inputFiles.forEach(p -> {

            try {
                lines.add(format("    // %s (%d bytes)", p.toString(), size(p)));
            } catch (IOException e) {
                lines.add(format("    // %s: %s", p.toString(), e.getMessage()));
            }

        });

        lines.add("}");

        Path packageDirectory = outputDirectory.resolve(packageName);

        if (!isDirectory(packageDirectory)) {
            createDirectories(packageDirectory);
        }

        lines.replaceAll(l -> StringEscapeUtils.escapeJava(l));

        write(packageDirectory.resolve(format("%s.java", className)), lines);

        return 0;
    }

}
