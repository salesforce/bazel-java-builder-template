package(default_visibility = ["//visibility:public"])
load(":tree.bzl", "tree")

java_library(
    name = "project-lib",
    srcs = glob(["*.java"]),
)

tree(
    name = "target",
    builder = "@builder//:builder-java-maven_deploy.jar",
)