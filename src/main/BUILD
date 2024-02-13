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

pkg_files(
    name = "dummy_manifest",
    srcs = ["MANIFEST.MF"],
    strip_prefix = strip_prefix.files_only(),
    prefix = "META-INF/",
)

# create the jar for java_import
pkg_zip(
    name ="mybuilder_resourcejar",
    srcs = [":mybuilder_resource_files", ":dummy_manifest"],
    package_file_name = "mybuilder_resources.jar",
)

# make it available to java_library
java_import(
    name = "mybuilder_resources_from_java_import",
    jars = [":mybuilder_resourcejar"],
    visibility = ["//src/main/java/com/salesforce/bazel/javabuilder/mybuilder:__pkg__", "//:__pkg__"],
)

# https://github.com/bazelbuild/bazel/issues/15111 or
# https://github.com/spring-projects/spring-framework/issues/28230
java_library(
    name = "mybuilder_resources_from_java_library",
    resources = glob(include = ["resources/**"]),
    resource_strip_prefix = "src/main/resources",
    visibility = ["//src/main/java/com/salesforce/bazel/javabuilder/mybuilder:__pkg__", "//:__pkg__"],
)
