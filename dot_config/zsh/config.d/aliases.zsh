alias ll="ls -lahG"
# Set python 3 as our default python interpreter - seems this python is included from xcode tools
alias python="/usr/bin/python3"

# Journaling shortcuts
J=$HOME/Projects/personal/journal
alias journal="mkdir -p $J/$(date +'%Y/%m') && code $J/$(date +'%Y/%m/%Y-%m-%d.md')"

alias install_toolbox="prompt_install bazel ~/.config/zsh/installs/bazelisk.zsh"

