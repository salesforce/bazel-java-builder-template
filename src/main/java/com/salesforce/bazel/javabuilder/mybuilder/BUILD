package(default_visibility = ["//visibility:public"])
java_binary(
    name = "mybuilder",
    srcs = [
        ":mybuilder_files",
    ],
    javacopts = [
        "-source 1.8",
        "-target 1.8",
    ],
    main_class = "com.salesforce.bazel.javabuilder.mybuilder.MyBuilderInvoker",
    visibility = ["//visibility:public"],
    deps = [
        "//src/main/java/com/google/devtools/build/lib/worker",
        "//src/main/java/com/salesforce/bazel/javabuilder/worker",
        "@mybuilder_rules_guava//jar",
        "@mybuilder_rules_picocli//jar",
    ],
)

filegroup(
    name = "mybuilder_files",
    srcs = [
        "MyBuilderCommand.java",
        "MyBuilderInvoker.java",
    ],
    visibility = ["//visibility:public"],
)
