load("@salesforce_rules_mybuilder//mybuilder:defs.bzl", "mybuilder_gen_java_library")
load("@rules_java//java:defs.bzl", "java_library")

package(default_visibility = ["//visibility:public"])

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
    deps = ["mybuilder_sources"],
)

mybuilder_gen_java_library(
    name = "mybuilder_sources",
    srcs = [":mybuilder_input"],
)
