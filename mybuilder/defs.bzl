def _mybuilder_gen_impl(ctx):
    # scala/private/rule_impls.bzl: def compile_scala

    resources = ctx.files.srcs
    current_target = ctx.label
    output_dir = ctx.outputs.gendir
    output_jar = ctx.outputs.srcjar

    mybuilder_args = """--input={srcs}
--output={out}
--current-target={current_target_name}
""".format(
        srcs = ",".join([f.path for f in resources]),
        srcs_short_paths = ",".join([f.short_path for f in resources]),
        out = output_dir.path,
        current_target_name = current_target.name,
    )

    argfile = ctx.actions.declare_file(
        "%s_mybuilder_worker_input" % current_target.name,
        sibling = output_jar,
    )

    ctx.actions.write(
        output = argfile,
        content = mybuilder_args,
    )

    mybuilder = ctx.attr._mybuilder
    mybuilder_inputs, _, mybuilder_input_manifests = ctx.resolve_command(
        tools = [mybuilder],
    )

    inputs = resources + mybuilder_inputs + [argfile]

    # run code generator
    ctx.actions.run(
        inputs = inputs,
        outputs = [output_dir],
        executable = mybuilder.files_to_run.executable,
        input_manifests = mybuilder_input_manifests,
        mnemonic = "MyBuilder",
        progress_message = "mybuilder generating sources %s" % current_target.name,
        execution_requirements = {"supports-workers": "1"},
        arguments = ["@" + argfile.path],
    )

    # force timestamps to harmonize for deterministic artifacts
    #ctx.actions.run_shell(
    #    inputs = inputs + [output_dir],
    #    outputs = [output_dir],
    #    command = "find $1 -exec touch -t 198001010000 {{}} \;",
    #    arguments = [output_dir.path],
    #)

    jdk = ctx.attr._jdk
    jdk_inputs, _, jdk_input_manifests = ctx.resolve_command(
        tools = [jdk],
    )

    # generate srcjar
    ctx.actions.run_shell(
        inputs = inputs + [output_dir] + jdk_inputs,
        outputs = [output_jar],
        progress_message = "mybuilder generating srcjar %s" % current_target.name,
        command = "$1 cMf $2 -C $3 .",
        arguments = ["%s/bin/jar" % ctx.attr._jdk[java_common.JavaRuntimeInfo].java_home, output_jar.path, output_dir.path],
    )

mybuilder_gen = rule(
    attrs = {
        "srcs": attr.label_list(
            allow_empty = False,
            doc = "MyBuilder example input for .txt files",
            allow_files = [".txt"],
        ),
        "gendir": attr.output(
        	doc = "A directory where '.java' files are generated into.",
        	mandatory = True,
        ),
        "srcjar": attr.output(
        	doc = "The 'targetname'.srcjar file containing the generated '.java' sources for compilation.",
        	mandatory = True,
        ),
        "_jdk": attr.label(
            default = Label("@bazel_tools//tools/jdk:current_java_runtime"),
            providers = [java_common.JavaRuntimeInfo],
        ),
        "_mybuilder": attr.label(
            default = Label(
                "//src/main/java/com/salesforce/bazel/javabuilder/mybuilder",
            ),
        ),
    },
    fragments = ["java"],
    implementation = _mybuilder_gen_impl,
    doc = """
Generates a `.srcjar` file for consumption by Bazel and IDEs for further compilation.
""",
)
