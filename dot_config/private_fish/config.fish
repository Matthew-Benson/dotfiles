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
