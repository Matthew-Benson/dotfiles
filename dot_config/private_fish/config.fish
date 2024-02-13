# https://fishshell.com/docs/current/language.html#configuration-files

if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
end
eval "$(/opt/homebrew/bin/brew shellenv)"
