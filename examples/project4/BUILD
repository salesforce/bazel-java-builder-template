package(default_visibility = ["//visibility:public"])
#load("@example_builder//mybuilder:mybuilder.bzl", "mybuilder")

deps = ["//project1:project1"]
java_library(
    name = "project4-lib",
    srcs = glob(["*.java"]),
    deps = deps,
)


# Not running the Builder in this module
#mybuilder(
#    name = "mybuilder",
#    builder = "@example_builder//:mybuilder_deploy.jar",
#)
