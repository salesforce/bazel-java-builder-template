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

import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

import com.google.common.base.CaseFormat;
import com.google.common.base.CharMatcher;

import picocli.CommandLine.Command;
import picocli.CommandLine.Option;

@Command(name = "mybuilder", description = "A sample builder which generates a file")
public class MyBuilderCommand implements Callable<Integer> {

    private static String normalizePath(Object input) {
        // Windows outputs '\' which breaks .java files
        return String.valueOf(input).replace('\\', '/');
    }

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

        Resource[] result = collectResources();
        if (result.length != 2)
            throw new IllegalStateException("Resources not loaded correctly from classpath!");

        List<String> lines = new ArrayList<>();
        lines.add(format("package %s;", packageName));
        lines.add("");
        lines.add(format("public class %s {", className));
        lines.add("");
        lines.add(format("    // user.dir: %s", normalizePath(System.getProperty("user.dir"))));
        lines.add(format("    //      '.': %s", normalizePath(get(".").toAbsolutePath().normalize())));
        lines.add("");
        lines.add(format("    //   output: %s", normalizePath(outputDirectory)));
        lines.add(format("    //           %s (normalized)", normalizePath(outputDirectory.toAbsolutePath().normalize())));
        lines.add("");
        inputFiles.forEach(p -> {

            try {
                lines.add(format("    // %s (%d bytes)", normalizePath(p), size(p)));
            } catch (IOException e) {
                lines.add(format("    // %s: %s", normalizePath(p), e.getMessage()));
            }

        });

        lines.add("}");

        Path packageDirectory = outputDirectory.resolve(packageName);

        if (!isDirectory(packageDirectory)) {
            createDirectories(packageDirectory);
        }

        write(packageDirectory.resolve(format("%s.java", className)), lines);

        return 0;
    }

    /**
     * This method simulated resource collection from classpath.
     * <p>
     * This might be useful if your build code uses Spring PathMatchingResourcePatternResolver or other similar libraries.
     * </p>
     *
     * @return a set of URLs
     * @throws IOException
     */
    private Resource[] collectResources() throws IOException {
        final PathMatchingResourcePatternResolver resolver =
                new PathMatchingResourcePatternResolver(MyBuilderCommand.class.getClassLoader());
        return resolver.getResources("classpath*:/files/*.txt");
    }

}
