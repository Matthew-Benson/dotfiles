#!/usr/bin/env fish

# TODO: how to source bazel.fish for helpers?
# source

# TODO: how to install for MacOS? There's a brew package but it's using a different implementation.
# Depends: libc6 (>= 2.34)
# Homepage: http://mama.indstate.edu/users/ice/tree/
# TODO: this depends on GNU cut - we will need to use nixpkg?

function install
    if test "$CHEZMOI_OS" = 'linux' && test "$CHEZMOI_OS_RELEASE_ID" = 'debian'
        sudo apt-get install -y tree
    else
        echo 'UNIMPLEMENTED' && return 1
    end
end

function uninstall
    if test "$CHEZMOI_OS" = 'linux' && test "$CHEZMOI_OS_RELEASE_ID" = 'debian'
        sudo apt-get remove -y tree
    else
        echo 'UNIMPLEMENTED' && return 1
    end
end

function update
    install
end

# returns a string like 'v2.1.0'
function get_version
    tree --version | cut -d' ' -f2
end

function print_help
    echo "Install or update 'tree' to a desired version (if possible) based on whether tree is currently installed."
    echo "-v or --version is required."
end

# TODO: should be optional? Maybe a doc on how to do tracing and how to debug?
# set -x fish_trace true

# env | sort

# TODO: wrap main function for better debugging - i.e. source/breakpoint?
# TODO: add to doc - sh_binary respects shebangs, but we can't append PATH
# so we have a bit of a workaround to get hermetic fish...
# https://nix-bazel.build/
# we will use nix to provide access to a wide range of dependable, pre-build
# system tools and programs. Would be better to compile them all ourselves
# with bazel but that's a complicated large effort.

# echo "we made it!"
# echo "$BAZEL_FISH"
# tree
# source rules_fish/bazel.fish
echo "hello fish, from"
status current-command
status fish-path
status current-commandline
source $BAZEL_FISH or echo "failed to source $BAZEL_FISH" and return 1
# TODO: how to "or" error check the rlocation when it happens in a subshell? it fails now, probably because we nuked this dep.
set -l FOO $(rlocation "rules_nixpkgs_core~0.10.0~nix_pkg~fish/bin/fish")
echo $FOO
exit 0

set -l options h/help 'v/version='
argparse -n install_tree $options -- $argv
or return

if set -q _flag_help
    print_help
    return 0
end

if test -z "$_flag_version"
    print_help
    return 1
end

if not type -q tree
    install
else if test get_version != "$_flag_version"
    update
end
