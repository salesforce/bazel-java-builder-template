workspace(name = "com_salesforce_bazel_javabuilder_rules_mybuilder")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# runtime dependencies
load("//mybuilder:repositories.bzl", "rules_mybuilder_dependencies")
rules_mybuilder_dependencies()

# development time dependencies
http_archive(
    name = "rules_pkg",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/0.6.0/rules_pkg-0.6.0.tar.gz",
        "https://github.com/bazelbuild/rules_pkg/releases/download/0.6.0/rules_pkg-0.6.0.tar.gz",
    ],
    sha256 = "62eeb544ff1ef41d786e329e1536c1d541bb9bcad27ae984d57f18f314018e66",
)
load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")
rules_pkg_dependencies()
