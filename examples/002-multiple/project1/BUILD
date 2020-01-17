package(default_visibility = ["//visibility:public"])
load("@rules_mybuilder//mybuilder:defs.bzl", "mybuilder_gen")

filegroup(
    name = "mybuilder_input",
    srcs = glob(
        [
            "src/main/java/resources/**/*.txt",
        ],
    ),
)

filegroup(
    name = "project1_sources",
    srcs = glob(
        [
            "src/main/java/**/*.java",
        ],
    ),
)

java_library(
    name = "project1",
    srcs = [
        "project1_sources",
    ],
    resources = [":mybuilder_input"],
    deps = ["mybuilder_jar"],
)

java_library(
    name = "mybuilder_jar",
    srcs = [
        "project1_generated.srcjar",
    ],
)

mybuilder_gen(
    name = "mybuilder_sources",
    srcs = [":mybuilder_input"],
    gendir = "project1_generated",
    srcjar = "project1_generated.srcjar",
)
