"""Fish download helper functions. WIP.

Reference go_toolchain and llvm for example:

https://github.com/bazelbuild/rules_go/blob/c0ef535977f9fd2d9a67243552cd04da285ab629/go/private/sdk.bzl#L56
https://github.com/bazel-contrib/toolchains_llvm/blob/96b5eee584450963408be7c33b695ae457ad93e8/toolchain/deps.bzl 
"""

def _fish_multiple_toolchains_impl(repository_ctx):
    print("_fish_multiple_toolchains_impl")
    _fish_download_impl(repository_ctx)
    repository_ctx.file(
        "BUILD.bazel",
        fish_toolchains_build_file_content(
            repository_ctx,
            versions = repository_ctx.attr.versions,
        ),
        executable = False,
    )

fish_multiple_toolchains = repository_rule(
    implementation = _fish_multiple_toolchains_impl,
    attrs = {
        "versions": attr.string_list(mandatory = True),
        # TODO: there IS a mirror available from fishshell.com: https://github.com/fish-shell/fish-shell?tab=readme-ov-file#building-from-source
        "urls": attr.string_list(default = ["https://github.com/fish-shell/fish-shell/releases/download/{version}/fish-{version}.tar.xz"]),
        "sha256": attr.string(default = "614c9f5643cd0799df391395fa6bbc3649427bb839722ce3b114d3bbc1a3b250"),
        "_fish_build_file": attr.label(
            default = Label("//rules_fish:BUILD.fish.bazel"),
        ),
    },
)

def _fish_download_impl(repository_ctx):
    print("_fish_download_impl")
    version = repository_ctx.attr.versions[0]
    print(version)

    # TODO: we could do better with string formatting here ...
    _remote_fish(repository_ctx, [url.format(version = version) for url in repository_ctx.attr.urls], repository_ctx.attr.sha256)

    repository_ctx.template(
        "fish/BUILD.bazel".format(version = version),
        repository_ctx.path(repository_ctx.attr._fish_build_file),
        executable = False,
        substitutions = {
            "{version}": version,
        },
    )

    # TODO: this logic needs improved
    if not repository_ctx.attr.versions:
        # Returning this makes Bazel print a message that 'version' must be specified for a reproducible build.
        return {
            "version": version,
        }
    return None

def _remote_fish(repository_ctx, urls, sha256):
    print("_remote_fish")
    if len(urls) == 0:
        fail("no urls specified")

    repository_ctx.report_progress("Downloading and extracting Fish toolchain")

    repository_ctx.download_and_extract(
        url = urls,
        sha256 = sha256,
        output = "fish",
        stripPrefix = "fish-3.7.1",
    )

def fish_download_release(name, register_toolchains = True, **kwargs):
    print("fish_download_release")

    _fish_toolchains(
        name = name + "_toolchains",
        version = kwargs.get("version"),
    )

# TODO: re-sort this madness in the end
def _fish_toolchains(name, version):
    print("_fish_toolchains")
    fish_multiple_toolchains(name = name, versions = [version])

def fish_toolchains_single_definition(repository_ctx, version):
    print("fish_toolchains_single_definition")

    chunks = []
    loads = []

    loads.append("""load(":fish_toolchain.bzl", "fish_toolchain")""")

    chunks.append("""toolchain_type(
    name = "toolchain_type",
    visibility = ["//visibility:public"],
)

fish_toolchain(
    name = "fish_linux",
)
""")

    # TODO: These platform references didn't work - did we need another load? Seems that resolved it. see:
    # bazel query --output=build @fish_toolchains//:all
    # OH https://bazel.build/extending/platforms
    # I think we need to pull in https://github.com/bazelbuild/platforms
    # https://github.com/bazelbuild/rules_go/blob/db019639425b18db040094fb5e34c8c8ca90c864/MODULE.bazel#L12
    # TODO: how to link the correct toolchain_type and create the platform_common.ToolchainInfo() provider?
    chunks.append("""toolchain(
    name = "fish_linux_toolchain",
    exec_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    target_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    toolchain = ":fish_linux",
    toolchain_type = ":toolchain_type",
    # toolchain_type = "//rules_fish:toolchain_type",
)
""")
    return struct(
        loads = loads,
        chunks = chunks,
    )

def fish_toolchains_build_file_content(repository_ctx, versions):
    print("fish_toolchains_build_file_content")

    TOOLCHAIN = """
FishInfo = provider(
    doc = "Information about how to invoke the barc compiler.",
    # In the real world, compiler_path and system_lib might hold File objects,
    # but for simplicity they are strings for this example. arch_flags is a list
    # of strings.
    fields = ["compiler_path", "system_lib", "arch_flags"],
)

def _fish_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        fishinfo = FishInfo(),
    )
    return [toolchain_info]

fish_toolchain = rule(
    implementation = _fish_toolchain_impl,
    attrs = {},
)
"""
    repository_ctx.file(
        "fish_toolchain.bzl",
        executable = False,
        content = TOOLCHAIN,  # TODO: would be better to read file
    )

    loads = [
        """""",
    ]
    chunks = [
        """package(default_visibility = ["//visibility:public"])""",
    ]

    for i in range(len(versions)):
        definition = fish_toolchains_single_definition(
            repository_ctx,
            version = versions[i],
        )
        loads.extend(definition.loads)
        chunks.extend(definition.chunks)

    return "\n".join(loads + chunks)

def fish_register_toolchains(version = None):
    print("fish_register_toolchains")
    fish_download_release("fish", register_toolchains = True, version = version)

# TODO: must support some fish_toolchain_dependencies rule to get the c++ build deps as part of toolchain.
# TODO: define a BUILD.fish.bazel to use for the repository_rule impl.
# TODO: we need a repository rule to deal with download the release archive.
# We should start with a minimal version that just downloads Fish 3.7.1
# TODO: need to write toolchain registration, but impl minimal - only Linux x64 w/ Fish 3.7.1
