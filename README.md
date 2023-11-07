# dotfiles

<!-- TODO: change macos specific config to use chezmoi templates https://www.chezmoi.io/user-guide/templating and doc this -->
<!-- TODO: add SSH keys, etc. from 1Password -->
<!-- TODO: set default login shell? Link to a doc? -->
<!-- TODO: tmux config? Can we set a better moderning scrolling option? -->
<!-- TODO: fzf/fd integration with fish -->

Personal dotfiles configurations for Linux, MacOS, and Windows for terminals and other configurables.

To bring this configuration to a new system, use [chezmoi](https://www.chezmoi.io/).

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply matthew-benson
```

On Windows:

```powershell
# To install in ./bin
(iwr -UseBasicParsing https://git.io/chezmoi.ps1).Content | powershell -c -

# To install in another location
'$params = "-BinDir ~/other"', (iwr https://git.io/chezmoi.ps1).Content | powershell -c -

# For information about other options, run
'$params = "-?"', (iwr https://git.io/chezmoi.ps1).Content | powershell -c -
```

See https://www.chezmoi.io/docs/install/ for more.

See also: [chezmoi quick start guide](https://www.chezmoi.io/quick-start/).

## Linux/MacOS ZSH Theme

### Fonts

Install meslo-nerd and configure for Linux/MacOS:

https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k

Plugins and oh-my-zsh are managed by chezmoi, but versions for releases in the config may need updated from time to time.

## Dependencies

<!-- TODO: scrap toolbox/install tooling, write playbooks. Tool infrequent to automate and keep working. No tests, etc. -->
<!-- there's also a chance we use templates and some other chezmoi features? -->

Install fzf and fd to find/search with hotkeys and good default file ignores

https://github.com/junegunn/fzf

https://github.com/sharkdp/fd


## Making Changes

There are a few approaches outlined in this doc:
[How do I edit my dotfiles with chezmoi](https://www.chezmoi.io/user-guide/frequently-asked-questions/usage/#how-do-i-edit-my-dotfiles-with-chezmoi)?

The best approaches are using `chezmoi edit --apply $FILE` to apply the changes when you quit your editor, and
`chezmoi edit --watch $FILE` to apply the changes whenever you save the file.

Alternatively, edit the file in your home directory, and then either re-add it by running `chezmoi add $FILE` or
`chezmoi re-add`.

You can also open the local chezmoi repo in your editor then use `chezmoi apply` to sync all changes to your
home directory.

## Updating Chezmoi

```sh
chezmoi upgrade
```

## Updating External Files

```sh
chezmoi -R apply
```

See [Dealing with State Drift](#dealing-with-state-drift).

## Dealing with State Drift

Sometimes the local state of dotfiles in the home directory becomes different from the state in the local chezmoi
repo. `chezmoi diff` will show the changes between the local chezmoi repo and the contents of the home directory.

Very often, files from `.oh-my-zsh` will be updated automatically and cause a state diff between local chezmoi repo and
the home directory. These can be updated with `chezmoi -R apply`. This will prompt for an overwrite for every changed
file, and because this can be a lot, typically you choose "all-override". See [External Files](#external-files).

## External Files

`chezmoi managed` outputs all files managed by Chezmoi, including files created by external dependencies. To date in
this repo, that's mainly just files from `.oh-my-zsh`. These can be filtered out with the following command:

```sh
chezmoi managed | awk '!/.oh-my-zsh/'
```

This is helpful, for instance, for external dependencies managed by `.chezmoiexternal.toml`, which are external
files that are treated as if they are in the source state, but are not tracked by git. An external dependency like
`.oh-my-zsh` includes hundreds of files that will appear in the output of `chezmoi diff` or `chezmoi managed` if not
ignored, which makes it hard to discern quickly whether a diff shows a drift in state from repo source or not. See
[chezmoiexternal reference](https://www.chezmoi.io/reference/special-files-and-directories/chezmoiexternal-format/)
and [Dealing with State Drift](#dealing-with-state-drift).

For `file` and `archive` externals, chezmoi will cache downloaded URLs. The optional duration `refreshPeriod` field
specifies how often chezmoi will re-download the URL. The default is zero meaning that chezmoi will never re-download
unless forced. To force chezmoi to re-download URLs, pass the `-R`/`--refresh-externals` flag. Suitable refresh periods
include one day (`24h`), one week (`168h`), or four weeks (`672h`).

