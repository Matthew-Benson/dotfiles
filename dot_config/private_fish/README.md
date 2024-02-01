# Fish Overview

## Bass
To update Bass, clone the repo https://github.com/edc/bass and `make install`.

## Google Cloud SDK

gcloud and gsutil completions are copied from https://github.com/lgathy/google-cloud-sdk-fish-completion.

## Podman

podman completions are manually created/updated in `completions/`.
https://docs.podman.io/en/stable/markdown/podman-completion.1.html.

```sh
podman completion -f ~/.config/fish/completions/podman.fish fish
chezmoi add ~/.config/fish/completions/podman.fish
```

## NVM

There's a completely different NVM implementation from the same person who wrote Fisher
here - https://github.com/jorgebucaran/nvm.fish. Naturally, they want you to install with
Fisher, but I disagree, so here are the install instructions as I see it.

```sh
cd /tmp
gh repo clone jorgebucaran/nvm.fish
cd nvm.fish
cp completions/nvm.fish $__fish_config_dir/completions/
cp conf.d/nvm.fish $__fish_config_dir/conf.d/
# write all these functions into one file
mkdir -p /tmp/output
set FUNCTIONS (ls functions/ | sort -r)
for f in $FUNCTIONS
    cat "functions/$f" >> /tmp/output/nvm.fish
end
cp /tmp/output/nvm.fish $__fish_config_dir/functions/

chezmoi add $__fish_config_dir/completions/nvm.fish
chezmoi add $__fish_config_dir/conf.d/nvm.fish
chezmoi add $__fish_config_dir/functions/nvm.fish
```

## Bazel

Bazel completions are built from the source repo and copied into completions via these instructions:
https://github.com/bazelbuild/bazel/blob/master/scripts/fish/README.md.

## Aliases
Aliases are created in `functions/` via `alias --save <name> <definition>`.
https://fishshell.com/docs/current/cmds/alias.html.
