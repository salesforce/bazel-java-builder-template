package(default_visibility = ["//visibility:private"])
java_library(
    name = "mybuilder",
    srcs = [
        ":mybuilder_files",
    ],
    visibility = ["//:__pkg__"],
    deps = [
        "//src/main/java/com/google/devtools/build/lib/worker",
        "//src/main/java/com/salesforce/bazel/javabuilder/worker",
        "@mybuilder_rules_guava",
        "@mybuilder_rules_picocli",
        "@mybuilder_rules_spring_core",
    ],
    runtime_deps = [
    	"@mybuilder_rules_org_slf4j_simple",
        "//src/main:mybuilder_resources"
    ],
)

filegroup(
    name = "mybuilder_files",
    srcs = [
        "MyBuilderCommand.java",
        "MyBuilderInvoker.java",
    ],
    visibility = [":__pkg__"],
)
