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
