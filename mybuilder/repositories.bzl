load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@bazel_tools//tools/build_defs/repo:jvm.bzl", "jvm_maven_import_external")

def rules_mybuilder_dependencies(
        maven_servers = ["https://repo1.maven.org/maven2/"]):
    # used by MyBuilderProcessor
    jvm_maven_import_external(
        name = "mybuilder_rules_commons_io",
        artifact = "commons-io:commons-io:2.6",
        artifact_sha256 = "",
        licenses = ["notice"],
        server_urls = maven_servers,
    )

    jvm_maven_import_external(
        name = "mybuilder_rules_guava",
        artifact = "com.google.guava:guava:28.1-jre",
        artifact_sha256 = "30beb8b8527bd07c6e747e77f1a92122c2f29d57ce347461a4a55eb26e382da4",
        licenses = ["notice"],
        server_urls = maven_servers,
    )

    jvm_maven_import_external(
        name = "mybuilder_rules_picocli",
        artifact = "info.picocli:picocli:4.0.4",
        artifact_sha256 = "8e532fb4a2f118a87c77b4e12a3565550f2dd7ec34d865c837e2a23728a45a48",
        licenses = ["notice"],
        server_urls = maven_servers,
    )

    maybe(
        http_archive,
        name = "com_google_protobuf",
        sha256 = "d82eb0141ad18e98de47ed7ed415daabead6d5d1bef1b8cccb6aa4d108a9008f",
        strip_prefix = "protobuf-b4f193788c9f0f05d7e0879ea96cd738630e5d51",
        # Commit from 2019-05-15, update to protobuf 3.8 when available.
        url = "https://github.com/protocolbuffers/protobuf/archive/b4f193788c9f0f05d7e0879ea96cd738630e5d51.tar.gz",
    )

    maybe(
        # needed by com_google_protobuf
        http_archive,
        name = "zlib",
        build_file = "@com_google_protobuf//:third_party/zlib.BUILD",
        strip_prefix = "zlib-1.2.11",
        urls = ["https://zlib.net/zlib-1.2.11.tar.gz"],
        sha256 = "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1",
    )

    maybe(
        # needed by com_google_protobuf
        http_archive,
        name = "bazel_skylib",
        url = "https://github.com/bazelbuild/bazel-skylib/releases/download/0.9.0/bazel_skylib-0.9.0.tar.gz",
        sha256 = "1dde365491125a3db70731e25658dfdd3bc5dbdfd11b840b3e987ecf043c7ca0",
    )

    native.bind(
        name = "com_salesforce_bazel_javabuilder_rules_mybuilder/dependency/com_google_protobuf/protobuf_java",
        actual = "@com_google_protobuf//:protobuf_java",
    )

    native.bind(
        name = "com_salesforce_bazel_javabuilder_rules_mybuilder/dependency/commons_io/commons_io",
        actual = "@mybuilder_rules_commons_io//jar",
    )

    native.bind(
        name = "com_salesforce_bazel_javabuilder_rules_mybuilder/dependency/info_picocli/picocli",
        actual = "@mybuilder_rules_picocli//jar",
    )

    native.bind(
        name = "com_salesforce_bazel_javabuilder_rules_mybuilder/dependency/com_google_guava/guava",
        actual = "@mybuilder_rules_guava",
    )
