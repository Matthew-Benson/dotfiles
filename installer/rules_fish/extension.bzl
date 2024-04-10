load(":download.bzl", "fish_register_toolchains")

def _download_fish_impl(module_ctx):
    for mod in module_ctx.modules:
        for toolchain in mod.tags.toolchain:
            fish_register_toolchains(toolchain.version)

_toolchain = tag_class(attrs = dict(version = attr.string()))
download_fish = module_extension(
    implementation = _download_fish_impl,
    tag_classes = {
        "toolchain": _toolchain,
    },
)
