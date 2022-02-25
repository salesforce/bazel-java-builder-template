# Bazel Java Builder Template
A template for wrapping a based Java source generator (eg., Maven Takari based mojos) and bring it into Bazel.

## Prerequisite

Before diving into writing Bazel rules for your source generator please learn about the fundamentals of Bazel and Bazel rules.

* [Intro to Bazel](https://bazel.build/start/bazel-intro)
  * [Workspaces, packages, and targets](https://bazel.build/concepts/build-ref)
  * [Best Practices](https://bazel.build/docs/best-practices)
* [Extension overview](https://bazel.build/rules/concepts)
  * [Macros](https://bazel.build/rules/macros)
  * [Rules](https://bazel.build/rules/rules)
* [Starlark Language](https://bazel.build/rules/language)
* [.bzl style guide](https://bazel.build/rules/bzl-style)

You should be able to explain the use of actions, action graph, macros vs. rules, packages vs. targets, repository rules and sandboxing.
If you can't please do not continue unless you can.


## Setup

If you want to use the latest stable release, add the following:

```bzl
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "salesforce_rules_mybuilder",
    url = "https://github.com/salesforce/bazel-java-builder-template/releases/download/....tar.gz",
    sha256 = "....",
)

load("@salesforce_rules_mybuilder//mybuilder:repositories.bzl", "rules_mybuilder_dependencies", "rules_mybuilder_toolchains")
rules_mybuilder_dependencies()
rules_mybuilder_toolchains()
```

If you want to use a specific commit (for example, something close to `master`), add the following instead:

```bzl
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

git_repository(
    name = "salesforce_rules_mybuilder",
    remote = "https://github.com/salesforce/bazel-java-builder-template.git",
    commit = "...",
)

load("@salesforce_rules_mybuilder//mybuilder:repositories.bzl", "rules_mybuilder_dependencies", "rules_mybuilder_toolchains")
rules_mybuilder_dependencies()
rules_mybuilder_toolchains()
```

If you want to use a local clone (eg., for development purposes) you can override both repository definitions (`git_repository` and `http_archive`) from the command line:

```bash
git clone git@github.com:salesforce/bazel-java-builder-template.git /Users/me/development/bazel-java-builder-template/

cd ~/blt/app/main/core
bazel build --override_repository=salesforce_rules_mybuilder=/Users/me/development//bazel-java-builder-template/
```


## How it works

This template was heavily inspired by [rules_scala](https://github.com/bazelbuild/rules_scala/) and [rules_avro](https://github.com/meetup/rules_avro).
It follows the recommendation given by [Deploying Rules](https://bazel.build/rules/deploying).
It's designed to allow wrapping existing Java builders (eg., like Maven Takari builders) for Bazel.
These builders don't need to be pre-built.
Instead they will be compiled as part of the Bazel build using those.

Support for [persistent workers](https://medium.com/@mmorearty/how-to-create-a-persistent-worker-for-bazel-7738bba2cabb) is included.

* Clone this Git repo
* Copy your builder source code into `src/main/java`
* Add the builder dependencies to `pom.xml` and to `builder_rules` function (see [defs.bzl](mybuilder/defs.bzl)).
* Use the `rename.sh` script to rename the rules.


## Contribution Guide

This project uses both: **Maven** *and* **Bazel**.
Maven is used for best IDE experience.
Bazel is used for command line build and delivery.

Few things to keep in mind:
* The Bazel build files are source of truth for producing deliverables, i.e. don't bother adding Maven plug-ins to `pom.xml` files.
* Maven drives Eclipse M2E for development of this tool. Nothing more.
* Don't get too fancy with Bazel, though. It has to map to Maven for IDE classpath computation.
* We'll eventually switch from M2E to the Bazel plug-in once it's more usable.
