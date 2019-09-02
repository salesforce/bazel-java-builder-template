# Bazel Java Builder Template
A template for wrapping any Java builder (eg., Maven Takari builder) and bring it into Bazel.

## How it works

This template was heavily inspired by [rules_scala](https://github.com/bazelbuild/rules_scala/).
It's designed to allow wrapping existing Java builders (eg., like Maven Takari builders) for Bazel.
These builders don't need to be pre-built.
Instead they will be compiled as part of the Bazel build using those.

Support for [persistent workers](https://medium.com/@mmorearty/how-to-create-a-persistent-worker-for-bazel-7738bba2cabb) is included.

* Clone this Git repo
* Copy your builder source code into `src/main/java`
* Add the builder dependencies to `pom.xml` and to `builder_rules` function (see [mybuilder.bzl](mybuilder/mybuilder.bzl)).
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
