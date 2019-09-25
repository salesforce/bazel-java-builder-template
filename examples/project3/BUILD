package(default_visibility = ["//visibility:public"])
load("@example_builder//mybuilder:mybuilder.bzl", "mybuilder")

deps = ["//project2:project2"]

filegroup(
    name = "resources",
    srcs = glob([
      "src/main/java/resources/**",
        ],
        exclude = ["**/*.java"],
    ),
)

java_library(
    name = "project3",
    srcs = glob(["*.java"]),
    deps = deps,
    resources = ["//project3:resources"],
)

mybuilder(
    name = "mybuilder",
    builder = "@example_builder//:mybuilder_deploy.jar",
    deps = ["//project3:resources"]
)
