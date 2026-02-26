# TODO: take arg for base and branch name
# TODO: arg for whether to apply
# TODO: tab completions for fish and jj?
# TODO: use gh to get head and base by PR repo + number?
# TODO: would be nice to jj describe from PR description.
# TODO: complimentary tool that takes a patch file created on top this one, diffs it, and submits feedback in GitHub discussion? How to create comments on line numbers: https://stackoverflow.com/a/78064959. Can use comment flags like the Linux project or something like sourcehut's recommended?

function patch_from_pr
    set -l base (jj show -r $argv[0] -T 'self.commit_id()' --no-patch)
    set -l head (jj show -r $argv[1] -T 'self.commit_id()' --no-patch)
    # set -l base (jj show -r 'trunk()' -T 'self.commit_id()' --no-patch)
    # set -l head (jj show -r 'sumpter/mwPersonToPlayerApis@origin' -T 'self.commit_id()' --no-patch)

    # TODO: if we want to use this later, we might have to put it somewhere else and use some well-known name.
    set -l tmp (mktemp --suffix=.patch)
    git diff $base..$head >$tmp

    jj new $base
    git apply $tmp

    echo 'jj delta-split'
    echo hx
    echo 'to review changes'
    echo 'jj abandon'
    echo 'when finished'
end
