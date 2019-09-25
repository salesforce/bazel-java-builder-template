package(default_visibility = ["//visibility:public"])
load("@example_builder//mybuilder:mybuilder.bzl", "mybuilder")



filegroup(
    name = "resources",
    srcs = glob([
      "src/main/java/resources/**",
        ],
        exclude = ["**/*.java"],
    ),
)



java_library(
    name = "project1",
    srcs = glob(["*.java"]),
    resources = ["//project1:resources"],
)

mybuilder(
    name = "mybuilder",
    builder = "@example_builder//:mybuilder_deploy.jar",
    deps = [//project1:resources],
)
