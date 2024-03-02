#!/usr/bin/env fish

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
