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

## Bazel

Bazel completions are built from the source repo and copied into completions via these instructions:
https://github.com/bazelbuild/bazel/blob/master/scripts/fish/README.md.

## Aliases
Aliases are created in `functions/` via `alias --save <name> <definition>`.
https://fishshell.com/docs/current/cmds/alias.html.
