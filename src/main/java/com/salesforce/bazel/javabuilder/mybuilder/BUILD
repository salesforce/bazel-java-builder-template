package(default_visibility = ["//visibility:private"])

_DEPS = [
    "//src/main/java/com/google/devtools/build/lib/worker",
    "//src/main/java/com/salesforce/bazel/javabuilder/worker",
    "@mybuilder_rules_guava",
    "@mybuilder_rules_picocli",
    "@mybuilder_rules_spring_core",
]

filegroup(
    name = "mybuilder_files",
    srcs = glob(["*.java"]),
    visibility = [":__pkg__"],
)

java_library(
    name = "mybuilder_using_library",
    srcs = [":mybuilder_files"],
    visibility = ["//:__pkg__"],
    runtime_deps = [
        "//src/main:mybuilder_resources_from_java_library",
        "@mybuilder_rules_org_slf4j_simple",
    ],
    deps = _DEPS + ["@mybuilder_rules_org_slf4j_api"],
)

java_library(
    name = "mybuilder_using_import",
    srcs = [":mybuilder_files"],
    visibility = ["//:__pkg__"],
    runtime_deps = [
        "//src/main:mybuilder_resources_from_java_import",
        "@mybuilder_rules_org_slf4j_simple",
    ],
    deps = _DEPS + ["@mybuilder_rules_org_slf4j_api"],
)
