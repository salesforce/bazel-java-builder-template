package(default_visibility = ["//visibility:public"])
load("@example_builder//mybuilder:mybuilder.bzl", "mybuilder")

deps = ["//project1:project1"]

filegroup(
    name = "resources",
    srcs = glob([
      "src/main/java/resources/**",
        ],
        exclude = ["**/*.java"],
    ),
)



java_library(
    name = "project2",
    srcs = glob(["*.java"]),
    deps = deps,
    resources = ["//project2:resources"],
)



mybuilder(
    name = "mybuilder",
    builder = "@example_builder//:mybuilder_deploy.jar",
    deps = ["//project2:resources"],
)
