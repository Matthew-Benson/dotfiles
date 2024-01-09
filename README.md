# dotfiles

<!-- TODO: change macos specific config to use chezmoi templates https://www.chezmoi.io/user-guide/templating and doc this -->
<!-- TODO: add SSH keys, etc. from 1Password -->
<!-- TODO: set default login shell? Link to a doc? -->
<!-- TODO: tmux config? Can we set a better moderning scrolling option? -->
<!-- TODO: fzf/fd integration with fish -->
<!-- TODO: fish level of info/context we're getting with zsh + Powerlevel10k? -->
<!-- TODO: chezmoi diff exclude things we don't care about: https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/#set-environment-variables and track this config file -->
<!-- TODO: ~/.config/chezmoi/chezmoi.toml git autopush https://www.chezmoi.io/user-guide/daily-operations/#automatically-commit-and-push-changes-to-your-repo -->
<!-- TODO: set EDITOR and VISUAL ? what are the ENVs to make tools use vim and vscode when possible? -->
<!-- TODO: recommend editor extensions for txtpb -->
<!-- TODO: chezmoi ignore (it's called something else in this case) diffs from oh-my-zsh plugins and other noisy diff sources -->
<!-- TODO: set ZDOTDIR into ~/.config or ~/.local so things like zcompdump isn't in home directory -->
<!-- TODO: Starship instead of p10k? https://github.com/starship/starship - default styling isn’t great, but it’s very customizable - can search sourcegraph for examples? Has 30k+ stars, have to have lots of examples out there in the wild. -->
<!-- TODO: Chezmoi ignore license and readme? -->
<!-- TODO: Need to add to dotfiles docs: Need to add to dotfiles docs: wanted to use font ligatures in my current terminals (Apple default and Gnome terminal) but apparently not supported. Was pointed to Kitty and Konsole. Kitty’s maintainer apparently hates tmux as a concept and won’t fully support it (I use in remote workflows to persist state) but also won’t provide an alternative. I found wezterm when looking around for alternatives and it seems much better? why wezterm? https://wezfurlong.org/wezterm/config/font-shaping.html we can keep wezterm config font ligatures settings for monaspace in dotfiles. It also has a remote state management solution for non-tmux -->
<!-- TODO: https://unix.stackexchange.com/q/516800 for tmux config? -->
<!-- TODO: mouse=a vimrc -->

<!-- TODO: starship config
     - only show gcloud in prompt if we type gcloud like p10k
     - improved path/PWD
     - kubectl info doesn't pop up when using it?
     - segmented prompt elements?
     - there are a number of commands that SHOULD enable/disable starship features based on the command line buffer. i.e. if you're using gcloud, we should show gcloud prompt info above. if you're using kubectl, we should show context info. We can compose some shell commands that read/write CLI buffer and startship CLI to make this work. https://fishshell.com/docs/current/cmds/commandline.html https://github.com/starship/starship/issues/5509 though we should expand on the solution presented here as it won't address aliases etc. If we're doing this, how much value add is starship anyway? Maybe we need https://fishshell.com/docs/current/cmds/bind.html#special-input-functions repaint after changing config? But this is just hard with fish. See https://github.com/IlanCosman/tide/issues/90 - is there some kind of starship way to hook a function on drawing prompt so we can check fish buffer every change?
-->

<!-- TODO: chsh -s /usr/bin/fish $USER -->
<!-- TODO: Add some kind of tunnel-client logic with chezmoi ? Is there some OSS alternative to cloudflared? Not REALLY. Tailscale has some similar offerings, but not 100% open source as far as I can tell. -->
<!-- TODO: write Sapling Fish completions with same strategy they use for Bazel? i.e. generate them with some python scripting. -->
<!-- TODO: enable bash history timestamps and improve basic usability like color, prompt, etc. for interactive shells. -->
<!-- TODO: Integration with Sourcegraph? Sourcegraph is built like an internal google product https://sourcegraph.com/code-search/pricing and seems quite good vs opengrok -->
<!-- TODO: Some way we can implement https://markdown-here.com/ to email client? Generally, we probably just need a better email client, but I've seen terminal email clients which I won't rule out so I'll doc this here. -->
<!-- TODO: Remove system fzf and manage through git repo download? Install / key binds for fish just aren’t working at all. -->
<!-- TODO: Fish fzf/fd for directories and files? Already has builtin for history. Seems like there are some other finder hotkeys. -->
<!-- TODO: Set login shell to fish? Either way, zsh NEEDS updated and it’s not well documented on README. Need to add fish configs too… -->
<!-- TODO: Sl zsh completion problem bc we don’t have hg -->
<!-- TODO: Add to sapling doc about adding status to CLI like we have with Powerlevel10k and git? I think the problem I experienced and wound up hiding yesterday was because I should have used push to instead of pr.Add to sapling doc about adding status to CLI like we have with Powerlevel10k and git? Oh, and vscode integration missing bottom bar info. -->
<!-- TODO: Oneof vs map vs listing all the install options? -->
<!-- TODO: shift+tab does a complete+pager-search which is really cool! Can we change pager to fzf? See https://fishshell.com/docs/3.3/interactive.html#shared-bindings -->
<!-- TODO: can we get a more native feeling fzf integration for fish? I like the default fish search / history feature, I just want some fzf matching features -->
<!-- TODO: I would LIKE a vscode replacement for something in-terminal (I think I can do better than vscode and be more portable with clever configs and tooling) but what is reasonable? neovim - I think I would need to write LOADS of Lua to make it nice. Helix - Casper uses this and it's well recieved here https://programming.dev/post/7612048 but I don't know much about it. Upon further inspection, I actually agree with Casper and MAY migrate to using Helix. -->
<!-- TODO: uhhhh, my installer ideas... don't work right... We cannot allow chezmoi to potentially parallel any jobs to install/update programs - we must depend on a single program (some python probably, but a Go binary is reasonable if we can reasonably deliver it based on os/arch) that will deal with the dependency graph. For example, I want to install Helix-editor, but on Debian 12, I must build from source. To build requires Cargo, which we can reasonably get, but really should be managed by the cargo install job. What's a reasonable tool to deal with this complex dependency graph? Feels like a Bazel problem, but we aren't building code, so that's not it. Could take a stage-0, stage-1, stage-2... approach which is okay, but brittle because we don't know what we're dealing with in the future. -->
<!-- TODO: Hmm, chezmoi scripts will execute in alphabetical order. We can EASILY do a run_onchange_0-bootstrap.sh, run_onchange1-tools.py, etc. -->
<!-- TODO: if we put dependencies into a bazel structure, we can use bazel query to get a graph of that and possibly decide install order? Can automate CI to get a nice DAG into an svg image with graphviz https://graphviz.org/ apt install graphviz -->
<!-- TODO: if we use 0-boostrap to install bazelisk then 1-tools to use bazel to run some install scripts, can we 1. modify script behavior based on platform? 2. use chezmoi's templating? 3. make bazel execute scripts in order rather than just defining deps/runfiles? -->
<!-- we can output some useful graph with something like: bazel query --notool_deps --noimplicit_deps "deps(//:install_helix)" --output=graph -->

Personal dotfiles configurations for Linux, MacOS, and Windows for terminals and other configurables.

To bring this configuration to a new system, use [chezmoi](https://www.chezmoi.io/).

See the [install instructions from chezmoi docs](https://www.chezmoi.io/install/#one-line-binary-install) for more.
Typically, install via the following.

> NOTE: run in home directory for this to write the correct directory.

```sh
sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --apply matthew-benson
```

Also create `chezmoi.toml` config file that cannot be managed by chezmoi:

```sh
cat <<EOF > $HOME/.config/chezmoi/chezmoi.toml
[diff]
    exclude = ["externals"]
EOF
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

Scripts depend on python 3+ and are needed to manage external targets.

<!-- TODO: link python3 installation docs? -->
<!-- TODO: some kind of blocking/warning when python not found? -->

<!-- TODO: scrap toolbox/install tooling, write playbooks. Tool infrequent to automate and keep working. No tests, etc. -->
<!-- there's also a chance we use templates and some other chezmoi features? -->
<!-- Yes, we can manage macos/linux differences with some clever templating: https://www.chezmoi.io/user-guide/machines/linux/ -->

<!-- Install fzf and fd to find/search with hotkeys and good default file ignores

https://github.com/junegunn/fzf

https://github.com/sharkdp/fd -->

<!-- TODO: I should need bat too for fzf's preview feature -->
<!-- TODO: I would like to keep fish's existing style for history search -->


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

## Development

<!-- TODO: write about how to add to dotfiles -->

### Dependencies

<!-- TODO: install links -->

- Python 3+
- `protoc`
