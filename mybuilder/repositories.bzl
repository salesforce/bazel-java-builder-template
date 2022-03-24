load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@bazel_tools//tools/build_defs/repo:jvm.bzl", "jvm_maven_import_external")

def rules_mybuilder_dependencies(
        maven_servers = ["https://repo1.maven.org/maven2/"]):
    """
    Defines run-time dependencies for the Java builder.

    Any dependency not required for running this build (eg., for tests or packaging) should
    go into the WORKSPACE file in the project root.

    Note, as a best practice, all dependencies are prefixed with "mybuilder_rules_". This was done
    in order to avoid collisions between the dependencies a builder uses and dependencies
    the project using a builder has. Users can still override any of the dependencies defined
    here by declaring a jvm_maven_import_external before calling this method. Bazel has a
    first-one wins rule.

    Args:
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
        artifact_sha256 = "42e98f58f53d1a49fd734c2dd193880f2dfec3436a2993a00d06b8800a22a3f2",
        licenses = ["notice"],
        server_urls = maven_servers,
    )

    jvm_maven_import_external(
        name = "mybuilder_rules_org_slf4j_api",
        artifact = "org.slf4j:slf4j-api:1.7.30",
        artifact_sha256 = "cdba07964d1bb40a0761485c6b1e8c2f8fd9eb1d19c53928ac0d7f9510105c57",
        licenses = ["notice"],
        server_urls = maven_servers,
    )

    jvm_maven_import_external(
        name = "mybuilder_rules_org_slf4j_simple",
        artifact = "org.slf4j:slf4j-simple:1.7.30",
        artifact_sha256 = "8b9279cbff6b9f88594efae3cf02039b6995030eec023ed43928748c41670fee",
        licenses = ["notice"],
        server_urls = maven_servers,
    )

    jvm_maven_import_external(
        name = "mybuilder_rules_org_slf4j_jul_to_slf4j",
        artifact = "org.slf4j:jul-to-slf4j:1.7.30",
        artifact_sha256 = "bbcbfdaa72572255c4f85207a9bfdb24358dc993e41252331bd4d0913e4988b9",
        licenses = ["notice"],
        server_urls = maven_servers,
    )

    jvm_maven_import_external(
        name = "mybuilder_rules_org_slf4j_jcl_over_slf4j",
        artifact = "org.slf4j:jcl-over-slf4j:1.7.30",
        artifact_sha256 = "71e9ee37b9e4eb7802a2acc5f41728a4cf3915e7483d798db3b4ff2ec8847c50",
        licenses = ["notice"],
        server_urls = maven_servers,
    )

    jvm_maven_import_external(
        name = "mybuilder_rules_spring_core",
        artifact = "org.springframework:spring-core:5.3.17",
        artifact_sha256 = "a9a39bc84a91ab6489df07df027dd5520c037e617c9f69e21c422a6d3a77d28a",
        licenses = ["notice"],
        server_urls = maven_servers,
    )

    # development time dependencies
    maybe(
        http_archive,
        name = "rules_pkg",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/0.6.0/rules_pkg-0.6.0.tar.gz",
            "https://github.com/bazelbuild/rules_pkg/releases/download/0.6.0/rules_pkg-0.6.0.tar.gz",
        ],
        sha256 = "62eeb544ff1ef41d786e329e1536c1d541bb9bcad27ae984d57f18f314018e66",
    )

def rules_mybuilder_toolchains():
    # intentionally empty
    return
