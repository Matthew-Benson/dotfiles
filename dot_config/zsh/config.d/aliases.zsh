alias ll="ls -lahG"
# Set python 3 as our default python interpreter - seems this python is included from xcode tools
alias python="/usr/bin/python3"

# Journaling shortcuts
J=$HOME/Projects/personal/journal
alias journal="mkdir -p $J/$(date +'%Y/%m') && code $J/$(date +'%Y/%m/%Y-%m-%d.md')"

# TODO: this would be better served as a function called install_toolbox that could
# run prompt_install many times and pass args/flags like -i for interactive, -y for all yes, etc.
# build toolbox install prompt
INSTALL_SCRIPTS_DIR=$HOME/.config/zsh/installs
INSTALL_PROMPT=()
INSTALL_PROMPT+=("prompt_install bazel ${INSTALL_SCRIPTS_DIR}/bazelisk.zsh")
INSTALL_PROMPT+=("prompt_install go ${INSTALL_SCRIPTS_DIR}/go.zsh")
INSTALL_PROMPT+=("prompt_install buildifier ${INSTALL_SCRIPTS_DIR}/buildifier.zsh")
INSTALL_PROMPT+=("prompt_install buildozer ${INSTALL_SCRIPTS_DIR}/buildozer.zsh")
INSTALL_PROMPT+=("prompt_install unused_deps ${INSTALL_SCRIPTS_DIR}/unused_deps.zsh")
alias install_toolbox="$(joinByString ' && ' $INSTALL_PROMPT)"
