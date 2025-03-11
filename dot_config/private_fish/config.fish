# https://fishshell.com/docs/current/language.html#configuration-files

if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    atuin init fish --disable-up-arrow | source
end

if test -x /opt/homebrew/bin/brew
    eval "$(/opt/homebrew/bin/brew shellenv)"
end

if type -q direnv
    direnv hook fish | source
end

if type -q jj
    COMPLETE=fish jj | source
end

if type -q zoxide
    zoxide init fish | source
end

# pnpm
set -gx PNPM_HOME "/home/mbenson/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
