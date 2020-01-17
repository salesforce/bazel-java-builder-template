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
    name = "project4_sources",
    srcs = glob(
        [
            "src/main/java/**/*.java",
        ],
    ),
)

java_library(
    name = "project4",
    srcs = [
        "project4_sources",
    ],
    resources = [":mybuilder_input"],
    deps = ["//project1"],
)
