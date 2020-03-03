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
        name = "mybuilder_rules_slf4j_api",
        artifact = "org.slf4j:slf4j-api:1.7.25",
        artifact_sha256 = "18c4a0095d5c1da6b817592e767bb23d29dd2f560ad74df75ff3961dbde25b79",
        licenses = ["notice"],
        server_urls = maven_servers,
    )

    jvm_maven_import_external(
        name = "mybuilder_rules_slf4j_simple",
        artifact = "org.slf4j:slf4j-simple:1.7.25",
        artifact_sha256 = "0966e86fffa5be52d3d9e7b89dd674d98a03eed0a454fbaf7c1bd9493bd9d874",
        licenses = ["notice"],
        server_urls = maven_servers,
    )

    jvm_maven_import_external(
        name = "mybuilder_rules_jul_to_slf4j",
        artifact = "org.slf4j:jul-to-slf4j:1.7.25",
        artifact_sha256 = "416c5a0c145ad19526e108d44b6bf77b75412d47982cce6ce8d43abdbdbb0fac",
        licenses = ["notice"],
        server_urls = maven_servers,
    )

    jvm_maven_import_external(
        name = "mybuilder_rules_jcl_over_slf4j",
        artifact = "org.slf4j:jcl-over-slf4j:1.7.25",
        artifact_sha256 = "5e938457e79efcbfb3ab64bc29c43ec6c3b95fffcda3c155f4a86cc320c11e14",
        licenses = ["notice"],
        server_urls = maven_servers,
    )

def rules_mybuilder_toolchains():
    # intentionally empty
    return
