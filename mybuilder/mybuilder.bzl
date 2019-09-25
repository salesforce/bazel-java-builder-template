
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@bazel_tools//tools/build_defs/repo:jvm.bzl", "jvm_maven_import_external")



#Constants used
INPUT_FILE = "/tmp/dependency.txt"
OUTPUT_FILE = "/tmp/copy.txt"


def get_srcs(deps):
  return depset(
        deps)




def _impl(ctx):
    tree = ctx.actions.declare_directory(ctx.attr.name)
    srcs = get_srcs(ctx.files.deps)
    ctx.actions.run_shell(
        tools = [ctx.executable.builder],
        inputs = srcs,
        outputs = [tree],
        arguments = [tree.path],
        progress_message = "Running example builder '%s'" % ctx.executable.builder.path,
        command = """
java -jar {} -i {} -o {} 
""".format(ctx.executable.builder.path, INPUT_FILE, OUTPUT_FILE),
    )
    return [DefaultInfo(files=depset([tree]))]

mybuilder = rule(
    implementation = _impl,
    attrs = {
        "builder": attr.label(executable=True, cfg = "host", allow_files=True),
        "deps": attr.label_list(),
    },
)

def mybuilder_repositories(
        maven_servers = ["http://central.maven.org/maven2"]):


    # used by MyBuilderProcessor
    jvm_maven_import_external(
        name = "mybuilder_rules_commons_io",
        artifact = "commons-io:commons-io:2.6",
        jar_sha256 = "f877d304660ac2a142f3865badfc971dec7ed73c747c7f8d5d2f5139ca736513",
        licenses = ["notice"],
        server_urls = maven_servers,
    )

    jvm_maven_import_external(
        name = "mybuilder_rules_guava",
        artifact = "com.google.guava:guava:21.0",
        jar_sha256 = "972139718abc8a4893fa78cba8cf7b2c903f35c97aaf44fa3031b0669948b480",
        licenses = ["notice"],
        server_urls = maven_servers,
    )

    jvm_maven_import_external(
        name = "mybuilder_rules_picocli",
        artifact = "info.picocli:picocli:3.9.5",
        #jar_sha256 = "9bc4992d3b7d98885a2c42c301654f54b13a5747",
        licenses = ["notice"],
        server_urls = maven_servers,
    )

    if not native.existing_rule("com_google_protobuf"):
        http_archive(
            name = "com_google_protobuf",
            sha256 = "d82eb0141ad18e98de47ed7ed415daabead6d5d1bef1b8cccb6aa4d108a9008f",
            strip_prefix = "protobuf-b4f193788c9f0f05d7e0879ea96cd738630e5d51",
            # Commit from 2019-05-15, update to protobuf 3.8 when available.
            url = "https://github.com/protocolbuffers/protobuf/archive/b4f193788c9f0f05d7e0879ea96cd738630e5d51.tar.gz",
        )

    if not native.existing_rule("zlib"):  # needed by com_google_protobuf
        http_archive(
            name = "zlib",
            build_file = "@com_google_protobuf//:third_party/zlib.BUILD",
            sha256 = "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1",
            strip_prefix = "zlib-1.2.11",
            urls = ["https://zlib.net/zlib-1.2.11.tar.gz"],
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
