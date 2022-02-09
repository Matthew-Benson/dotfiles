# Custom functions:
# Accepts full command to generate command completions file.
# See example in .zshrc
function add_completions () {
  if [[ ! -d "$ZSH/completions" || ! -f "$ZSH/completions/_$1" ]]; then
    mkdir -p $ZSH/completions
    $@ > $ZSH/completions/_$1
    # echo "$1 added completions: $@ > $ZSH/completions/_$1"
  fi
}

