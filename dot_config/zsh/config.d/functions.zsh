# Custom functions:

# TODO: can we create source order or something? This has to load first if we want to use joinByString in aliases?

# https://dev.to/meleu/how-to-join-array-elements-in-a-bash-script-303a
joinByString() {
  local separator="$1"
  shift
  local first="$1"
  shift
  printf "%s" "$first" "${@/#/$separator}"
}

# Accepts full command to generate command completions file.
# See example in .zshrc
add_completions () {
  if [[ ! -d "$ZSH/completions" || ! -f "$ZSH/completions/_$1" ]]; then
    mkdir -p $ZSH/completions
    $@ > $ZSH/completions/_$1
    # echo "$1 added completions: $@ > $ZSH/completions/_$1"
  fi
}

# prompt for install if command not found, and call
# provided install script from 2nd parameter.
prompt_install () {
  readonly COMMAND=${1:?"The command must be specified."}
  readonly INSTALL_FUNC=${2:?"The install script must be specified."}
  IGNORE_FILE=$HOME/.config/zsh/installs/ignore.txt

  if type "${COMMAND}" >/dev/null 2>&1; then
    return 0 # if command installed, no need to prompt
  fi

  if grep -qs "${COMMAND}" $IGNORE_FILE; then
    return 0 # install prompt already ignored
  fi

  # TODO: chezmoi status

  while read "CHOICE?Would you like to install ${COMMAND}? [yes, no, never] "; do
    case $CHOICE in
      yes)
        $INSTALL_FUNC
        break;;
      no)
        break;;
      never)
        echo "${COMMAND}" >>$IGNORE_FILE
        break;;
      *)
        echo "unknown option";;
    esac
  done
}
