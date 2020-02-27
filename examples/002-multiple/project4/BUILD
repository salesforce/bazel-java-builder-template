load("@salesforce_rules_mybuilder//mybuilder:defs.bzl", "mybuilder_gen_java_library")
load("@rules_java//java:defs.bzl", "java_library")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "mybuilder_input",
    srcs = glob(
        [
            "src/main/resources/**/*.txt",
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
    deps = [":mybuilder_project4_sources", "//project1"],
)

mybuilder_gen_java_library(
    name = "mybuilder_project4_sources",
    srcs = [":mybuilder_input"],
)
