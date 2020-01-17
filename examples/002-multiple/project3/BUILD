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
    name = "project3_sources",
    srcs = glob(
        [
            "src/main/java/**/*.java",
        ],
    ),
)

java_library(
    name = "project3",
    srcs = [
        "project3_sources",
    ],
    resources = [":mybuilder_input"],
    deps = ["mybuilder_jar"],
)

java_library(
    name = "mybuilder_jar",
    srcs = [
        "project3_generated.srcjar",
    ],
)

mybuilder_gen(
    name = "mybuilder_sources",
    srcs = [":mybuilder_input", "//project1:mybuilder_input", "//project2:mybuilder_input"],
    gendir = "project3_generated",
    srcjar = "project3_generated.srcjar",
)
