package(default_visibility = ["//visibility:public"])
java_binary(
    name = "mybuilder",
    srcs = [
        "@com_salesforce_bazel_javabuilder_rules_mybuilder//src/main/java/com/salesforce/bazel/javabuilder/mybuilder/mybuilder:mybuilder_files",
    ],
    javacopts = [
        "-source 1.8",
        "-target 1.8",
    ],
    main_class = "com.salesforcebazel.javabuilder.mybuilder.MyBuilderInvoker",
    visibility = ["//visibility:public"],
    deps = [
        "@com_salesforce_bazel_rules_mybuilder//src/java/com/google/devtools/build/lib:worker",
        "@com_salesforce_bazel_rules_mybuilder//src/main/java/com/salesforce/bazel/javabuilder/worker",
        "@mybuilder_rules_commons_io//jar",
        "@mybuilder_rules_picocli//jar",
    ],
)

filegroup(
    name = "mybuilder_files",
    srcs = [
        "*.java",
    ],
    visibility = ["//visibility:public"],
)
