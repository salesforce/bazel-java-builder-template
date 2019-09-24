# Constants used

INPUT_FILE = "/tmp/dependency.txt"
OUTPUT_FILE = "/tmp/copy.txt"

def _impl(ctx):
    tree = ctx.actions.declare_directory(ctx.attr.name)
    ctx.actions.run_shell(
        tools = [ctx.executable.builder],
        outputs = [tree],
        arguments = [tree.path],
        progress_message = "Running example builder '%s'" % ctx.executable.builder.path,
        command = """
java -jar {} -i {} -o {} 
""".format(ctx.executable.builder.path, INPUT_FILE, OUTPUT_FILE),
    )
    return [DefaultInfo(files=depset([tree]))]

tree = rule(
    implementation = _impl,
    attrs = {
        "builder": attr.label(executable=True, cfg = "host", allow_files=True),
    },
)