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
