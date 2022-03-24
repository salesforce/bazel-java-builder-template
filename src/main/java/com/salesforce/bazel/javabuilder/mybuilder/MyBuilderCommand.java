package com.salesforce.bazel.javabuilder.mybuilder;

import static java.lang.String.format;
import static java.nio.file.Files.createDirectories;
import static java.nio.file.Files.isDirectory;
import static java.nio.file.Files.size;
import static java.nio.file.Files.write;
import static java.nio.file.Paths.get;
import static java.util.stream.Collectors.joining;

import java.io.IOException;
import java.net.URL;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.Callable;

import org.slf4j.Logger;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

import com.google.common.base.CaseFormat;
import com.google.common.base.CharMatcher;

import picocli.CommandLine.Command;
import picocli.CommandLine.Option;

@Command(name = "mybuilder", description = "A sample builder which generates a file")
public class MyBuilderCommand implements Callable<Integer> {

    private static Logger LOG = UnifiedLogger.getLogger();

    private static String normalizePath(Object input) {
        // Windows outputs '\' which breaks .java files
        return String.valueOf(input).replace('\\', '/');
    }

    @Option(names = {"-o", "--output"}, description = "output directory", required = true)
    private Path outputDirectory;

    @Option(names = {"-i", "--input"}, description = "input files", split = ",", required = true)
    private List<Path> inputFiles;

    @Option(names = {"--current-target"}, description = "target name", required = true)
    private String currentTarget;

    @Option(names = {"--verbose"}, description = "enable debug logging", negatable = true, defaultValue = "false")
    private boolean verbose;

    @Override
    public Integer call() throws Exception {
        if (verbose) {
            UnifiedLogger.enableDebugLogging();
        }

        String packageName = currentTarget.toLowerCase();
        String className = CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.UPPER_CAMEL, CharMatcher.is('-').replaceFrom(currentTarget, '_'));

        doResourceCollection();

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
    private void doResourceCollection() throws IOException {
        URL resource1 = getClass().getResource("/files/resource1.txt");
        LOG.debug("URL for '/files/resource1.text' is: {}", resource1);

        URL resource2 = getClass().getResource("/files/resource2.txt");
        LOG.debug("URL for '/files/resource2.text' is: {}", resource2);

        final PathMatchingResourcePatternResolver resolver =
                new PathMatchingResourcePatternResolver(MyBuilderCommand.class.getClassLoader());
        Resource[] result = resolver.getResources("classpath*:/files/*.txt");
        if (result.length == 0) {
            LOG.error("No results returned from classpath for 'classpath*:/files/*.txt'");
        }

        LOG.debug("Found resources:\n\n{}", Arrays.asList(result).stream().map(Resource::getDescription).collect(joining("\n")));
        if (result.length != 2)
            throw new IllegalStateException("Resources not loaded correctly from classpath!");
    }

}
