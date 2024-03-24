def _fish_binary_impl(ctx):
    # TODO: ctx.expand_location() could be used instead of runfiles ?
    # TODO: when moving to a full-on toolchain, this template should be os-dependant? i.e. Windows = ps1 and everyone else = sh?
    # print(ctx.attr.srcs)

    ctx.actions.expand_template(
        template = ctx.file._template,
        output = ctx.outputs.output,
        substitutions = {
            # TODO: this works, but don't understand the _main repo mapping ...? Where does this come from? Also what is the best path separator?
            # TODO: and should srcs be handled with rlocation or is this going to work well?
            "{SRCS}": ctx.attr.srcs[0].files.to_list()[0].path,
            "{FISH}": "_main/" + ctx.file._fish.path,
        },
    )

    executable = ctx.outputs.output
    deps = [executable]

    # print("deps", deps)

    # TODO: is this the right place for srcs? It works, but semantically best?
    fish_dependencies = [
        ctx.file._fish,
        ctx.file._runfiles_bash,
        ctx.file._rlocation_bash,
        ctx.file._bazel_fish,
    ] + ctx.attr.srcs[0].files.to_list()

    # print("fish_dependencies", fish_dependencies)
    runfiles = ctx.runfiles(files = ctx.files.data + ctx.files.deps + fish_dependencies)

    transitive_runfiles = []
    for runfiles_attr in (
        ctx.attr.srcs,
        ctx.attr.deps,
        ctx.attr.data,
    ):
        for target in runfiles_attr:
            transitive_runfiles.append(target[DefaultInfo].default_runfiles)
    runfiles = runfiles.merge_all(transitive_runfiles)

    # print("runfiles", runfiles.files)

    return [DefaultInfo(
        files = depset(deps),
        runfiles = runfiles,
        executable = executable,
    )]

fish_binary = rule(
    implementation = _fish_binary_impl,
    executable = True,
    outputs = {
        # TODO: how to format this name? don't use .sh either?
        "output": "fish.sh",
    },
    attrs = {
        # TODO: exactly one file - sh_binary calls this a singleton list.
        "srcs": attr.label_list(allow_files = True, mandatory = True),
        "data": attr.label_list(allow_files = True),
        "deps": attr.label_list(allow_files = True),  # TODO: enforce fish files and link these?
        "_fish": attr.label(
            default = Label("@fish//:bin/fish"),
            allow_single_file = True,
            executable = True,
            cfg = "exec",
        ),
        "_template": attr.label(
            default = ":fish_wrapper.sh",
            allow_single_file = True,
        ),
        "_runfiles_bash": attr.label(
            default = "@bazel_tools//tools/bash/runfiles",
            allow_single_file = True,
        ),
        "_rlocation_bash": attr.label(
            default = ":rlocation.sh",
            allow_single_file = True,
        ),
        "_bazel_fish": attr.label(
            default = ":bazel.fish",
            allow_single_file = True,
        ),
    },
)
