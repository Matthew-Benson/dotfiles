"""Fish download helper functions. WIP.

Reference go_toolchain and llvm for example:

https://github.com/bazelbuild/rules_go/blob/c0ef535977f9fd2d9a67243552cd04da285ab629/go/private/sdk.bzl#L56
https://github.com/bazel-contrib/toolchains_llvm/blob/96b5eee584450963408be7c33b695ae457ad93e8/toolchain/deps.bzl 
"""

def _fish_multiple_toolchains_impl(ctx):
    print("_fish_multiple_toolchains_impl")
    ctx.file(
        "BUILD.bazel",
        fish_toolchains_build_file_content(
            ctx,
            versions = ctx.attr.versions,
        ),
        executable = False,
    )

fish_multiple_toolchains = repository_rule(
    implementation = _fish_multiple_toolchains_impl,
    attrs = {
        "versions": attr.string_list(mandatory = True),
    },
)

def _fish_download_impl(ctx):
    print("_fish_download_impl")
    version = ctx.attr.version

    _remote_fish(ctx, [url.format(version) for url in ctx.attr.urls], ctx.attr.sha256)

    ctx.template(
        "BUILD.bazel",
        ctx.path(ctx.attr._sdk_build_file),
        executable = False,
        substitutions = {
            "{version}": version,
        },
    )

    if not ctx.attr.sdks and not ctx.attr.version:
        # Returning this makes Bazel print a message that 'version' must be
        # specified for a reproducible build.
        return {
            "name": ctx.attr.name,
            "goos": ctx.attr.goos,
            "goarch": ctx.attr.goarch,
            "sdks": ctx.attr.sdks,
            "urls": ctx.attr.urls,
            "version": version,
            "strip_prefix": ctx.attr.strip_prefix,
        }
    return None

def _remote_fish(ctx, urls, sha256):
    print("_remote_fish")
    if len(urls) == 0:
        fail("no urls specified")

    ctx.report_progress("Downloading and extracting Fish toolchain")

    ctx.download_and_extract(
        url = urls,
        sha256 = sha256,
    )

fish_download_release_rule = repository_rule(
    implementation = _fish_download_impl,
    attrs = {
        "urls": attr.string_list(default = ["https://github.com/fish-shell/fish-shell/releases/download/{version}/fish-{version}.tar.xz"]),
        "version": attr.string(),
        # FIXME
        "_fish_build_file": attr.label(
            default = Label("//rules_fish:BUILD.fish.bazel"),
        ),
    },
)

def fish_download_release(name, register_toolchains = True, **kwargs):
    print("fish_download_release")
    fish_download_release_rule(name = name, **kwargs)
    _fish_toolchains(
        name = name + "_toolchains",
        #     sdk_repo = name,
        #     sdk_type = "remote",
        version = kwargs.get("version"),
        #     goos = kwargs.get("goos"),
        #     goarch = kwargs.get("goarch"),
    )
    # if register_toolchains:
    #     _register_toolchains(name)

# TODO: re-sort this madness in the end
def _fish_toolchains(name, version):
    print("_fish_toolchains")
    fish_multiple_toolchains(name = name, versions = [version])

def fish_toolchains_single_definition(ctx, version):
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
    # native.toolchain(
    #     name = "fish_linux_toolchain",
    #     exec_compatible_with = [
    #         "@platforms//os:linux",
    #         "@platforms//cpu:x86_64",
    #     ],
    #     target_compatible_with = [
    #         "@platforms//os:linux",
    #         "@platforms//cpu:x86_64",
    #     ],
    #     toolchain = ":fish_linux",
    #     toolchain_type = ":toolchain_type",
    # )

    # native.toolchain(
    #         # keep in sync with generate_toolchain_names
    #         name = prefix + "go_" + p.name,
    #         toolchain_type = GO_TOOLCHAIN,
    #         exec_compatible_with = [
    #             "@io_bazel_rules_go//go/toolchain:" + host_goos,
    #             "@io_bazel_rules_go//go/toolchain:" + host_goarch,
    #         ],
    #         target_compatible_with = constraints,
    #         target_settings = [":" + prefix + "sdk_version_setting"],
    #         toolchain = go_toolchain_repo + "//:go_" + p.name + "-impl",
    #     )

# TODO: need to distinguish the types of ctx via param name across repo.
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

    # ctx.template(
    #     "BUILD.bazel",
    #     ctx.path(ctx.attr._sdk_build_file),
    #     executable = False,
    #     substitutions = {
    #         "{version}": version,
    #     },
    # )
    # TODO: .file() is better here?
    # repository_ctx.template(
    #     "fish_toolchain.bzl",
    #     repository_ctx.path(":fish_toolchain.bzl"),
    #     executable = False,
    # )
    loads = [
        # """load("@io_bazel_rules_go//go/private:go_toolchain.bzl", "declare_bazel_toolchains")""",
        """ """,
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

def _register_toolchains(repo):
    print("fish_toolchains_build_file_content")
    native.register_toolchains("@{}_toolchains//:all".format(repo))

def fish_register_toolchains(version = None):
    print("fish_register_toolchains")
    fish_download_release("fish", register_toolchains = True, version = version)

#     """See /go/toolchains.rst#go-register-toolchains for full documentation."""
#     if not version:
#         version = go_version  # old name

#     sdk_kinds = ("go_download_sdk_rule", "go_host_sdk_rule", "_go_local_sdk", "_go_wrap_sdk")
#     existing_rules = native.existing_rules()
#     sdk_rules = [r for r in existing_rules.values() if r["kind"] in sdk_kinds]
#     if len(sdk_rules) == 0 and "go_sdk" in existing_rules:
#         # may be local_repository in bazel_tests.
#         sdk_rules.append(existing_rules["go_sdk"])

#     if version and len(sdk_rules) > 0:
#         fail("go_register_toolchains: version set after go sdk rule declared ({})".format(", ".join([r["name"] for r in sdk_rules])))
#     if len(sdk_rules) == 0:
#         if not version:
#             fail('go_register_toolchains: version must be a string like "1.15.5" or "host"')
#         elif version == "host":
#             go_host_sdk(name = "go_sdk", experiments = experiments)
#         else:
#             pv = parse_version(version)
#             if not pv:
#                 fail('go_register_toolchains: version must be a string like "1.15.5" or "host"')
#             if _version_less(pv, MIN_SUPPORTED_VERSION):
#                 print("DEPRECATED: Go versions before {} are not supported and may not work".format(_version_string(MIN_SUPPORTED_VERSION)))
#             go_download_sdk(
#                 name = "go_sdk",
#                 version = version,
#                 experiments = experiments,
#             )

# TODO: must support some fish_toolchain_dependencies rule to get the c++ build deps as part of toolchain.
# TODO: define a BUILD.fish.bazel to use for the repository_rule impl.
# TODO: we need a repository rule to deal with download the release archive.
# We should start with a minimal version that just downloads Fish 3.7.1
# TODO: need to write toolchain registration, but impl minimal - only Linux x64 w/ Fish 3.7.1
