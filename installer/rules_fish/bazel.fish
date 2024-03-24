function rlocation
    # TODO: arg parsing
    # TODO: function doc comment
    set -l rlocation $(builtin realpath ./rlocation.sh)
    $rlocation $argv
end

function import --no-scope-shadowing
    # TODO: args parsing
    # TODO: translate the following to function doc comment:
    # calls rlocation.sh with args, gets resulting path
    # and prepends to PATH, automatically scoping the PATH variable
    # change to the calling function block. i.e.
    #  function myfunction
    #      echo $PATH # inherited from parent scope
    #      import "mydependency"
    #      echo $PATH # inherited PATH, prepended with path to "mydependency" as resolved by rlocation
    #  end
    #  echo $PATH # inherited from parent scope - does not include path to "mydependency"
    # TODO: demonstrate how to use this and dependency on path having rlocation.sh
    # ls -lagh rlocation.sh

    # TODO: path relative to self?
    # set -l rules_fish_dir $(dirname $(status --current-filename))
    # set -l rlocation $(builtin realpath ./rlocation.sh)
    # type --all rlocation.sh
    # TODO: how does this handle plurality? Should we write tests?
    set -l runfile_path $(rlocation $argv)
    echo $runfile_path
    set -l runfile_dir $(dirname $runfile_path)
    echo $runfile_dir
    echo $PATH
    set --function --prepend --path --export PATH $runfile_dir
    echo $PATH
end
