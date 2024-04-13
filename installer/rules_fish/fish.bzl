def _fish_binary_impl(ctx):
    # TODO: clean up this function - provide doc comments?
    # TODO: when moving to a full-on toolchain, this template should be os-dependant? i.e. Windows = ps1 and everyone else = sh?
    src = ctx.attr.srcs[0].files.to_list()[0]
    output_file = ctx.actions.declare_file(ctx.label.name)

    print("want:", "_main/external/_main~download_fish~fish_toolchains/fish/fish.build_tmpdir/fish")
    print("got :", "_main/" + ctx.file._fish.path)
    print("forcing fish path")

    ctx.actions.expand_template(
        template = ctx.file._template,
        output = output_file,
        substitutions = {
            # TODO: this works, but don't understand the _main repo mapping ...? Where does this come from? Also what is the best path separator?
            # I mean, I understand this is the _main/ as part of bzlmod repo, BUT other runfiles libs don't need this - is bash runfiles lookup
            # just in need of an update? I can't find any issues tracking this.
            # TODO: and should srcs be handled with rlocation or is this going to work well?
            "{SRCS}": src.path,
            # "{FISH}": "_main/" + ctx.file._fish.path,
            "{FISH}": "_main/external/_main~download_fish~fish_toolchains/fish/fish.build_tmpdir/fish",
        },
    )

    # TODO: this completely redundant?
    executable = output_file
    deps = [executable]

    # TODO: is this the right place for srcs? It works, but semantically best?
    fish_dependencies = [
        ctx.file._fish,
        ctx.file._runfiles_bash,
        ctx.file._rlocation_bash,
        ctx.file._bazel_fish,
    ]

    # print("fish_dependencies", fish_dependencies)
    runfiles_list = ctx.files.data + ctx.files.deps + [src] + fish_dependencies
    runfiles = ctx.runfiles(files = runfiles_list)

    transitive_runfiles = []
    for runfiles_attr in (
        ctx.attr.srcs,
        ctx.attr.deps,
        ctx.attr.data,
    ):
        for target in runfiles_attr:
            transitive_runfiles.append(target[DefaultInfo].default_runfiles)
    runfiles = runfiles.merge_all(transitive_runfiles)

    return [DefaultInfo(
        files = depset(deps),
        runfiles = runfiles,
        executable = executable,
    )]

fish_binary = rule(
    implementation = _fish_binary_impl,
    executable = True,
    attrs = {
        # TODO: exactly one file - sh_binary calls this a singleton list.
        "srcs": attr.label_list(allow_files = True, mandatory = True),
        "data": attr.label_list(allow_files = True),
        "deps": attr.label_list(allow_files = True),  # TODO: enforce fish files and link these?
        # "_fish": attr.label(
        #     default = Label("@fish//:bin/fish"),
        #     allow_single_file = True,
        #     executable = True,
        #     cfg = "exec",
        # ),
        "_fish": attr.label(
            # default = Label("@fish//:bin/fish"),
            default = Label("@fish_toolchains//fish:fish_bin"),
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
    # toolchains = ["//rules_fish:toolchain_type"],
    # TODO: HERE: replace _fish in impl with info = ctx.toolchains["@fish_toolchains//:toolchain_type"].fishinfo
    # Will also have to implement Build with foreign_cc rules?
    toolchains = ["@fish_toolchains//:toolchain_type"],
)
