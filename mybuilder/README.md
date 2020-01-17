# My Builder rules for [Bazel](https://bazel.build/)

## Setup

If you want to use the latest stable release, add the following:
```bzl
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_mybuilder",
    url = "https://github.com/salesforce/bazel-java-builder-template/releases/download/....tar.gz",
    sha256 = "....",
)

load("@rules_mybuilder//mybuilder:deps.bzl", "mybuilder_rules_dependencies", "mybuilder_register_toolchains")
mybuilder_rules_dependencies()
mybuilder_register_toolchains()
```

If you want to use a specific commit (for example, something close to `master`), add the following instead:
```bzl
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

git_repository(
    name = "rules_mybuilder",
    branch = "master",
    remote = "git@github.com:salesforce/bazel-java-builder-template.git",
)

load("@rules_mybuilder//mybuilder:deps.bzl", "mybuilder_rules_dependencies", "mybuilder_register_toolchains")
mybuilder_rules_dependencies()
mybuilder_register_toolchains()
```

