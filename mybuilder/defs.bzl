def _run_mybuilder(ctx):
    """This helper function runs the MyBuilder code generator and collects its output into a depset tree artifact.

    See the rule impl and rule definition for required attributes/inputs.

    Args:
     ctx: the context passed to the rule impl
    """
    current_target = ctx.label
    txt_resources = ctx.files.srcs

    # our builder requires an output directory for collecting the outputs in
    gen_dir = ctx.actions.declare_directory(
        "%s_generated" % current_target.name,
    )

    mybuilder_args = ctx.actions.args()
    mybuilder_args.add_joined("--input", txt_resources, join_with = ",")
    mybuilder_args.add("--output", gen_dir.path)
    mybuilder_args.add("--current-target", current_target.name)

    # Bazel requires a flagfile for worker mode,
    # either prefixed with @ or --flagfile= argument
    mybuilder_args.use_param_file("@%s", use_always = True)
    mybuilder_args.set_param_file_format("multiline")

    # run code generator
    ctx.actions.run(
        mnemonic = "MyBuilder",
        inputs = txt_resources,
        outputs = [gen_dir],
        executable = ctx.executable._mybuilder,
        execution_requirements = {"supports-workers": "1"},
        arguments = [mybuilder_args],
        progress_message = "mybuilder generating sources %s" % current_target.name,
    )

    return depset(direct = [gen_dir])

def _path_to_short_path_mapping_for_singlejar(file):
    """Helper for the singlejar tool to create a path with mapping.

    Args:
     file: the file object
    """
    return file.path + ":" + file.short_path

def _mybuilder_gen_impl(ctx):
    current_target = ctx.label

    # run the builder
    gen_dir = _run_mybuilder(ctx)
    gen_dir_files = gen_dir.to_list()

    # generate interim srcjar
    # (we use the singlejar tool here for normalizing timestamps)
    # note: this is a workaround until we can somehow read all the files
    # from gen_dir and give it to java_common.compile below
    srcjar = ctx.actions.declare_file("%s-gensrc.jar" % current_target.name)
    srcjar_args = ctx.actions.args()
    srcjar_args.add_all([
        "--normalize",
        "--compression",
    ])
    srcjar_args.add("--output", srcjar)
    srcjar_args.add_all(gen_dir_files, before_each = "--resources", map_each = _path_to_short_path_mapping_for_singlejar)
    ctx.actions.run(
        mnemonic = "MyBuildSrcJar",
        inputs = gen_dir_files,
        outputs = [srcjar],
        executable = ctx.executable._singlejar,
        arguments = [srcjar_args],
        progress_message = "Creating interim source jar %s for compilation" % srcjar.basename,
    )

    # compile the code
    java_info = java_common.compile(
        ctx,
        java_toolchain = ctx.attr._java_toolchain[java_common.JavaToolchainInfo],
        host_javabase = ctx.attr._host_javabase[java_common.JavaRuntimeInfo],
        source_jars = [srcjar],
        output = ctx.outputs.jar,
        output_source_jar = ctx.outputs.srcjar,
        deps = ctx.attr.deps,
        exports = ctx.attr.exports,
    )

    return [
        DefaultInfo(
            files = gen_dir,
        ),
        java_info,
    ]

mybuilder_gen = rule(
    doc =
        """Generates and compiles Java source code (`.jar` and a `.srcjar` file) for consumption by Bazel and IDEs.

    Args:
     srcs: Input for the code generator
     deps: Java dependencies for compiling the generated code.
     jar: the output jar name
     srcjar: the output source jar name
    """,
    attrs = {
        "srcs": attr.label_list(
            allow_empty = False,
            doc = "MyBuilder example input for .txt files",
            allow_files = [".txt"],
        ),
        "deps": attr.label_list(
            doc = "Compile time dependencies (see https://docs.bazel.build/versions/master/be/java.html#java_library).",
            allow_empty = True,
            providers = [JavaInfo],
        ),
        "exports": attr.label_list(
            doc = "Additional exports (see https://docs.bazel.build/versions/master/be/java.html#java_library).",
            allow_empty = True,
            providers = [JavaInfo],
        ),
        "jar": attr.output(
            doc = "The 'targetname'.jar file containing the compile Java code.",
            mandatory = True,
        ),
        "srcjar": attr.output(
            doc = "The 'targetname'.srcjar file containing the generated '.java' sources for compilation.",
            mandatory = True,
        ),
        "_mybuilder": attr.label(
            doc = "Implicit dependency to the java_binary for executing the source code generator.",
            default = Label(
                "//src/main/java/com/salesforce/bazel/javabuilder/mybuilder",
            ),
            cfg = "host",
            executable = True,
            allow_files = True,
        ),
        "_java_toolchain": attr.label(
            default = Label("@bazel_tools//tools/jdk:current_java_toolchain"),
            providers = [java_common.JavaToolchainInfo],
        ),
        "_host_javabase": attr.label(
            cfg = "host",
            default = Label("@bazel_tools//tools/jdk:current_java_runtime"),
            providers = [java_common.JavaRuntimeInfo],
        ),
        "_singlejar": attr.label(
            cfg = "host",
            default = Label("@bazel_tools//tools/jdk:singlejar"),
            executable = True,
            allow_files = True,
        ),
    },
    fragments = ["java"],
    provides = [JavaInfo],
    implementation = _mybuilder_gen_impl,
)

# declare any dependencies that the generated source requires for compilation here
MYBUILDER_DEPENDENCIES = []

def mybuilder_gen_java_library(
        name,
        **kwargs):
    """Macro with defaults for generating Java code for source code generated by `mybuilder_gen` rule.

    Some highlights why the macro is better than using the rule:
    - default values for `jar` name and `srcjar` name (based on `name`)
    - implicit builder dependencies (defined in MYBUILDER_DEPENDENCIES) for compilation (maintained by builder authors, no need for developers to worry about)

    Args:
      name: A unique name for this macro.
      **kwargs: Other attributes passed on to `mybuilder_gen` rule
    """

    # remove unwanted arguments
    kwargs.pop("jar", None)
    kwargs.pop("srcjar", None)

    # invoke rule
    mybuilder_gen(
        name = name,
        jar = "lib%s.jar" % name,
        srcjar = "lib%s-src.jar" % name,
        deps = kwargs.pop("deps", []) + MYBUILDER_DEPENDENCIES,
        **kwargs
    )
