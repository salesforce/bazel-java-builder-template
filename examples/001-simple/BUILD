load("@rules_mybuilder//mybuilder:mybuilder.bzl", "mybuilder_gen")

mybuilder_gen(
	name = "example",
    srcs = glob(
        ["src/resources/**/*.txt"],
    ),
    srcjar = "example_generated.srcjar",
    gendir = "example_generated",
)

