load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@bazel_tools//tools/build_defs/repo:jvm.bzl", "jvm_maven_import_external")

def rules_mybuilder_dependencies(
        maven_servers = ["https://repo1.maven.org/maven2/"]):
    """
    Defines run-time dependencies for the Java builder.

    Any dependency not required for running this build (eg., for tests or packaging) should
    go into the WORKSPACE file in the project root.

    Note, as a best practice, all dependencies are prefixed with "mybuilder_". This was done
    in order to avoid collisions between the dependencies a builder uses and dependencies
    the project using a builder has. Users can still override any of the dependencies defined
    here by declaring a jvm_maven_import_external before calling this method. Bazel has a
    first-one wins rule.

    maven_servers: list of Maven servers to fetch artifacts from
    """

    jvm_maven_import_external(
        name = "mybuilder_rules_guava",
        artifact = "com.google.guava:guava:28.2-jre",
        artifact_sha256 = "fc3aa363ad87223d1fbea584eee015a862150f6d34c71f24dc74088a635f08ef",
        licenses = ["notice"],
        server_urls = maven_servers,
    )

    jvm_maven_import_external(
        name = "mybuilder_rules_picocli",
        artifact = "info.picocli:picocli:4.2.0",
        artifact_sha256 = "d8cc74f00e6ae52e848539dfc7a05858dfe5cd19269491f8778efaa927665418",
        licenses = ["notice"],
        server_urls = maven_servers,
    )

    jvm_maven_import_external(
        name = "mybuilder_rules_protobuf_java",
        artifact = "com.google.protobuf:protobuf-java:3.11.4",
        artifact_sha256 = "",
        licenses = ["notice"],
        server_urls = maven_servers,
    )


def rules_mybuilder_toolchains():
    # intentionally empty
    return