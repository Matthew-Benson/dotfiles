
function __complete_packer
    set -lx COMP_LINE (commandline -cp)
    test -z (commandline -ct)
    and set COMP_LINE "$COMP_LINE "
    /usr/bin/packer
end
complete -f -c packer -a "(__complete_packer)"

