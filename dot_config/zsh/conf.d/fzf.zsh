# Any new environments (including dev containers) will depend on both fzf and fd being installed and in path.
# Configure fd to ignore .gitignore files. alias fdfind to fd if it's installed. (same program different name)
if command -v fdfind &> /dev/null; then
  alias fd="fdfind"
  export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
elif command -v fd &> /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
fi
# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
