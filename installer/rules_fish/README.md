# Issues

## Cmake fish build takes a long time

Building this with cmake takes ~2 minutes on my desktop. That's insane and greatly hampers development cycles.

## Create test harness to run the tests from the fish repo

Add test targets that use this toolchain with tests from
https://github.com/fish-shell/fish-shell/tree/master/tests
especially the checks directory.

## Create a variety of testing environments

NOTE: we also need to run that in some blank-slate container environment. Should also test MacOS manually.

## Create CI tests with a variety of platforms

Run simple CI on GitHub actions.

## Create additional rules

- fish_test
- fish_library

## Create docs

- how to run interactive and edit files interactively - this should support real targets and maybe source those files? funced -i myscript.fish? Create additional targets from fish_binary rule?
- how to use bazel deps
- how to lint - fish --no-execute ? How should users run this?
- how to format
- how to debug
- how to use a fish_binary in a genrule
- how to lint scripts for non-hermetic system dependencies
- how to run interactive fish with some default config, but not the user's home config
- how to get completions to work in this interactive mode (our toolchain is missing the share/ directory of output)

## Support different fish versions and configuring multiple toolchains

The plumbing is mostly there, but the e2e flow is just not supported - you will always get 3.7.1 from
the current toolchain.

## Support rust build for versions >= 3.8.0

Need a very different build file and a rust toolchain dependency to build and support the rust build of Fish.
Should probably wait until 3.8.0 releases.

## Move to standalone repo

If this will be used by others, my personal dotfiles are not the best place for this.

## Get shasum from the github releases page if unset

Use this to validate repository fetch.

## Create auto docs from bazel rules

Should define things like srcs, deps, and other accepted fields of rules like every other bazel library.

## Rewrite rlocation function in fish

Unfortunately, the rlocation function we're getting from bash rules actually doesn't work right with bzlmod.
We should instead copy the logic from the Go library [runfiles](https://pkg.go.dev/github.com/bazelbuild/rules_go/go/runfiles).

## Add Windows support

This is partially scaffolded out, but there's a long way to go. This would be a big win and improve hermetacity
vs system bash for genrules that need to support windows and scripts that need to be OS independent. 

- Need toolchain provider info to pick a fish.exe file.
- Need to make the fish wrapper base a powershell script rather than bash.

## Rename fish.bzl to defs.bzl akin to other libs

Rename `fish.bzl` to `defs.bzl`, refactor under path `fish/`, and add to repository rule so it
can be used by consumers like `load("@fish_toolchains//fish:defs.bzl", "fish_binary")`.

This is pretty standard for bazel libraries and we should aim to be consistent so it's
easy for adopters to use this and understand.

## Remove all references to nix packages

We aren't using this - it's not really hermetic for bazel as it requires a bunch of system setup.

## Support build from commit sha instead of release version

Since there's no release archive, we would have to do a git repo fetch, but I believe there's
a built in bazel lib function to pull a git repo.

## Support providing your own urls for fish repos

Some users will want to pull from their own URLs or at least provide their own backup URLs
through some artifact registry or pull-through cache.

## Support pulling a pre-built binary by url instead of building

Some users will want to pre-build fish for given platforms in a way that can be fetched
directly instead of building from source and we will need some plumbing to support this.

## Support system fish

Do we actually want to support this? Should it be safe to use the system fish shell?

Feels like that's not a useful use-case, but we will see if there's any interest.
Many other toolchains support system tools if they're properly configured for it.

## Support BSD?

Does Bazel support BSD as a platform? Can we support BSD will litle effort?

## Create a native bazel build for fish cc

This would take a ton of work but would greatly improve builds.

Would almost certainly need to automate this, otherwise we would
need to maintain many manual forks where we can ensure builds work correctly.

The Rust build would be much easier to automate with Gazelle.

## Capture and config out_data_dirs for fish cmake build's share/ dir

We need this for many builtin fish functions and completions.

TODO: BLOCKING

The following commands don't work currently - i.e. not found

```sh
psub
__fish_describe_command
echo $fish_complete_path # TODO: isn't set?
```

```sh
ll /usr/share/fish/
total 200K
drwxr-xr-x 2 root root 124K Mar 30 00:49 completions/
-rw-r--r-- 1 root root 8.6K Mar 18 23:40 config.fish
-rw-r--r-- 1 root root  452 Mar 19 01:26 __fish_build_paths.fish
drwxr-xr-x 2 root root  36K Mar 30 00:49 functions/
drwxr-xr-x 2 root root 4.0K Mar 30 00:49 groff/
drwxr-xr-x 3 root root 4.0K Nov 27 22:17 man/
drwxr-xr-x 3 root root 4.0K Mar 30 00:49 tools/
drwxr-xr-x 2 root root 4.0K Apr 10 09:05 vendor_completions.d/
drwxr-xr-x 2 root root 4.0K Feb  2 11:24 vendor_conf.d/
drwxr-xr-x 2 root root 4.0K Mar 25  2023 vendor_functions.d/
```

TODO: how to get share dir?

```sh
tree bazel-bin/external/_main~download_fish~fish_toolchains/fish/copy_fish/fish/ # thousands of files of output
tree -L 3 bazel-bin/external/_main~download_fish~fish_toolchains/fish/copy_fish/fish/ # digestable output:

bazel-bin/external/_main~download_fish~fish_toolchains/fish/copy_fish/fish/
├── bin
│   ├── fish
│   ├── fish_indent
│   └── fish_key_reader
├── etc
│   └── fish
│       ├── completions
│       ├── conf.d
│       ├── config.fish
│       └── functions
├── include
└── share
    ├── applications
    │   └── fish.desktop
    ├── doc
    │   └── fish
    ├── fish
    │   ├── completions
    │   ├── config.fish
    │   ├── __fish_build_paths.fish
    │   ├── functions
    │   ├── groff
    │   ├── man
    │   ├── tools
    │   ├── vendor_completions.d
    │   ├── vendor_conf.d
    │   └── vendor_functions.d
    ├── man
    │   └── man1
    ├── pixmaps
    │   └── fish.png
    └── pkgconfig
        └── fish.pc

25 directories, 9 files
```

```sh
# default env
INSTALLDIR=/tmp/bazel-working-directory/_main/bazel-out/k8-fastbuild/bin/external/_main~download_fish~fish_toolchains/fish/fish
# default install dir arg
-DCMAKE_INSTALL_PREFIX=/tmp/bazel-working-directory/_main/bazel-out/k8-fastbuild/bin/external/_main~download_fish~fish_toolchains/fish/fish
```

> Ah you can maybe get this weird path from something like `bazel cquery @fish_toolchains//pcre2:pcre2 --output=starlark`.

> bazel query --output=build @fish_toolchains//:all
> OH https://bazel.build/extending/platforms
> I think we need to pull in https://github.com/bazelbuild/platforms
> https://github.com/bazelbuild/rules_go/blob/db019639425b18db040094fb5e34c8c8ca90c864/MODULE.bazel#L12
> TODO: how to link the correct toolchain_type and create the platform_common.ToolchainInfo() provider?



TODO: keybinds don't work either - up does nothing, tab does nothing.


## Add optional dependencies to fish build

Includes ncurses and gettext?
https://invisible-island.net/archives/ncurses/

I think today the fish cmake build will still try to get ncurses from system, so that's not good.

## Clean up fish_binary rule to improve reliability

There are several TODOs that need addressed at the moment.

## Document how to use the standalone repo without pushing to bazel central registry

For a while, we will need to test the repo from some external repo and we don't want to
continually push update to BCR - it would be better to load this as a bazel module
directly with git or HTTP.

## Docs on running the built binary

`./bazel-bin/external/_main~download_fish~fish_toolchains/fish/fish/bin/fish --private`

## File name cleanup

When we move to a standalone repo, many of these file names add context that will be redundant
like `rules_fish/fish_toolchain.bzl` can just be `toolchain.bzl`.

Many file paths and labels will also break when this moves to another repo and will need a general
housekeeping effort to fix all of them.
