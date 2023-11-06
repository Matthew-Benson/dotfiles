# Custom functions:

# Accepts full command to generate command completions file.
# See example in .zshrc
#
# if $ZSH/completions not a directory or if $ZSH/completions/_$1 file does not exist
# 1. make completions dir (recursive create -p)
# 2. run all args as a bash command and write output to file $ZSH/completions/_$1
add_completions () {
  if [[ ! -d "$ZSH/completions" || ! -f "$ZSH/completions/_$1" ]]; then
    mkdir -p $ZSH/completions
    $@ > $ZSH/completions/_$1
    # echo "$1 added completions: $@ > $ZSH/completions/_$1"
  fi
}
