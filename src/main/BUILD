load("@rules_pkg//:mappings.bzl", "pkg_files", "strip_prefix")
load("@rules_pkg//:pkg.bzl", "pkg_zip")

package(default_visibility = ["//visibility:private"])

# create the file set for packaging
pkg_files(
    name = "mybuilder_resource_files",
    srcs = glob(include = ["resources/**"]),
    # drop everything from the tree up until the directory itself
    strip_prefix = strip_prefix.from_pkg("resources"),
    # where it should be in the final package
    prefix = None,
)

# create the jar for java_import
pkg_zip(
    name ="mybuilder_resourcejar",
    srcs = [":mybuilder_resource_files"],
    package_file_name = "mybuilder_resources.jar",
)

# make it available to java_library
java_import(
    name = "mybuilder_resources",
    jars = [":mybuilder_resourcejar"],
    visibility = ["//src/main/java/com/salesforce/bazel/javabuilder/mybuilder:__pkg__"],
)
