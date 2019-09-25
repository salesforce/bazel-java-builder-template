package(default_visibility = ["//visibility:public"])
load("//bazel-java-builder-template/mybuilder:mybuilder.bzl", "mybuilder")

java_library(
    name = "project-lib",
    srcs = glob(["*.java"]),
)

mybuilder(
    name = "mybuilder",
    builder = "@example_builder//:mybuilder_deploy.jar",
)