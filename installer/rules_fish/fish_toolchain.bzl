FishInfo = provider(
    doc = "Information about how to invoke fish shell.",
    fields = [],
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
