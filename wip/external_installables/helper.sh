#!/bin/false "This script should be sourced in a shell, not executed directly"

# TODO: argsparse handling? Should use some base helper like gbash and source it, but what?
# has anyone made a good type-safe arg parsing library for bash?

# TODO: proper function comment?

# install_or_upgrade will parse the given external installable (see protobuf definition external_installable.proto)
# in chezmoi state and system to decide whether to follow install logic or upgrade logic, and then execute that
# install/upgrade based on user prompts. This will also bump the installation state in chezmoi in the "scriptState"
# bucket under the key "externalInstallablesState.<my-installable>".
# For this, install_or_upgrade requires the following positional arguments:
#
# 1. absolute path to chezmoi executable - this can be grabbed from template variables.
# 2. absolute path to a textproto config file to parse for the given installable.
# 3. install executable (can be a function, script, or binary).
# 4. upgrade executable (can be a function, script, or binary).
install_or_upgrade() {
    CHEZMOI="$1"
    if [ ! -e "$CHEZMOI" ]; then
        echo "chezmoi not found, not executable, or not passed properly to helper.sh"
    fi

    PB="$2"
    if [ ! -f "$PB" ]; then
        echo "textproto not found or not passed properly to helper.sh"
    fi

    # TODO: check executable or function?
    INSTALL="$3"
    if command -v "$INSTALL" > /dev/null 2>&1; then
        echo "installer not found, not executable, or not passed properly to helper.sh"
    fi
    UPGRADE="$4"
    if command -v "$UPGRADE" > /dev/null 2>&1; then
        echo "upgrader not found, not executable, or not passed properly to helper.sh"
    fi

    # TODO: check for py?

    # parse
    _parse "$PB"
    # setenvs

    # check state
    name="fzf" # TODO: hardcoding for now until we impl parsing
    _read_state "$CHEZMOI" "$name"

    # prompt user about state information and whether to
    # install/upgrade, install/upgrade all, don't install/upgrade, never install/upgrade, never install/upgrade all ?
    # TODO: how many options to track? And how to store/read/define this?

    # install
    # write state
}

_parse() {
    # TODO: get realpath
    ./parse.py "$PB"
}

_read_state() {
    $CHEZMOI state get --bucket="scriptState" --key="externalInstallables.$INSTALLABLE_NAME.version"
}

_write_state() {
    # TODO: read/write PBs to state? Seems like JSON format needed :( but could transcode
    # could also stuff pb's into JSON but it's pretty hacky and hard to human-read
    $CHEZMOI state set --bucket="scriptState" --key="externalInstallables.$INSTALLABLE_NAME" --value='{"version": "asdf"}'
}

_install() {
    # TODO: install based on PB data ? Call individual installer script?
    $INSTALL
}

_upgrade() {
    $UPGRADE
}

# TODO: set ...

# TODO: wrap logic flow of install here?
# TODO: chezmoi change this file to executable

# Check py installed

# TODO: check functionality - should default to looking in path unless ENV set
# CHEZMOI=${CHEZMOI:chezmoi}

# TODO: better handling of args - should be flags?
# PB="$1"
# INSTALL="$2"
# UPGRADE="$3"
# CURRENT_VERSION="$4"

# TODO: check local thing version based on args? The run_ script that calls this SHOULD tell us local version?
# Nope, that wouldn't work - it doesn't yet know what platform or how to read the PB? Should the PB describe how
# to get the version? We can push it into state? But if state doesn't get upgraded, this isn't good source...

# PARSED_PB=$(parse.py "$PB")

# Check chezmoi state vs version in PB
# TODO: bucket scriptState? Nope, is used internally - nope, setting another bucket just fails successfully!
# $CHEZMOI state get --bucket="externalInstallablesState" --key="fzf.version"

# TODO: document how to view this state?
# chezmoi state get-bucket --bucket="externalInstallablesState"

# TODO: check version consensus of machine and chezmoi state

########################################################################################################################
# TODO: install/upgrade logic here
# IF "chezmoi state" == "" && "machine state" == ""
#   install.sh # from args
# IF "chezmoi state" == "1" && "machine state" == ""
#   install.sh # from args, but prompt user that state consensus broken
# IF "chezmoi state" == "" && "machine state" == "1"
#   upgrade.sh # from args, but prompt user that state consensus broken
# IF chezmoi state" != "machine state" && BOTH SET
#   upgrade.sh # from args, but prompt user that state consensus broken
# IF chezmoi state" == "machine state"
#   # echo to user that there's nothing to do
########################################################################################################################

# TODO: set state on exit
# $CHEZMOI state set --bucket="scriptState" --key="externalInstallablesState.fzf.version" --value="asdf"
#
# chezmoi state set --bucket="scriptState" --key="externalInstallablesState.fzf" --value='{"version": "asdf"}'
# chezmoi state get-bucket --bucket="scriptState"
# chezmoi state delete --bucket="scriptState" --key="externalInstallablesState.fzf"

# TODO: note in docs - they say to blow the bucket away to reset run state, but we would be blowing away installed thing
# state, so that's a bit of a problem! Need ... a different solution for changing state...
# https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/#clear-the-state-of-all-run_onchange_-and-run_once_-scripts
