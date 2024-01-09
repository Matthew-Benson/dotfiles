https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/

TODO: rename this directory to `.chezmoiscripts`

TODO:
use `run_onchange_` prefix scripts to download and install tools pinned to version files
in the repo. version file format is like `.nvmrc` or `.bazelversion`.

<!-- TODO: this directory tree needs updated. -->

```
chezmoi_scripts
|-- scripts
   |-- my_dep1
      |-- run_onchange_..._apt-install.bash
      |-- run_onchange_..._win-install.ps1
   |-- my_dep2
      |-- run_onchange_..._artifact-install.py
|-- versions
version.proto
```

TODO: our run_onchange should be py and it should select a more reasonable installer
and ch process to other thing? Set ENVs and pass to other script? We need py dependency
to parse the txtpb's AND I think we can only track one file to execute vs a file change?
No way to have a bash and powershell script run based on environment I don't think...

<!-- TODO: what happens if a run_ script fails but there are other waiting? -->
<!-- TODO: prompt for install on apply and record response/version data to state with another PB message -->
<!--       we want to be able to run on something like an alpine container and choose to install nothing. -->
<!--       though to support that, maybe the best first-layer would instead be a posix compliant #!/usr/bin/env sh -->
<!--       script rather than putting python first. Won't be as easy to script our installer-helper in POSIX bash. -->


Example install/upgrade flow for `fzf`:

<!-- TODO: update diagram - need some minor changes here -->

```
|---------| |---------------| |-----------------------------|   |-----------| |----------| |------------| |------------| |-----|
| chezmoi | | chezmoi apply | | run_onchange_install-fzf.py |   | fzf.txtpb | | parse.py | | install.sh | | upgrade.sh | | fzf |
|---------| |---------------| |-----------------------------|   |-----------| |----------| |------------| |------------| |-----|
     |-[CLI/install]|---->[exec as teml]---->|                        |             |             |              |          |
     |              |                        |->[templ loads shasum]->|             |             |              |          |
     |              |                        |<-[ & runs if diff   ]<-|             |             |              |          |
     |              |                        |                        |             |             |              |          |
     |              |                        |---->[parse fzf.txtpb for data]------>|             |              |          |
     |              |                        |<----[return message and set ENVs]<---|             |              |          |
     |              |                        |                        |             |             |              |          |
     |              |                        |----------------------->[check sys for install]------------------------------>|
     |<-[get version in chezmoi state]<------|                        |             |             |              |          |
     |              |                        |<-------------------[if consensus, continue, otherwise print help]------------|
     |              |                        |                        |             |             |              |          |
     |              |                        |-------->[install or upgrade depending on need]---->|------------->|          |
     |              |                        |<---------------[bubble exit status]<---------------|<-------------|          |
     |              |                        |                        |             |             |              |          |
     |<-[write new version/install state]<---|                        |             |             |              |          |
     |              |                        |                        |             |             |              |          |
     |              |<--------[exit]<--------|                        |             |             |              |          |
     |<---[exit]<---|                        |                        |             |             |              |          |
```

<!-- TODO: these files names are ... ??? -->
Notes about diagram:
- A script will run if the `run_` file itself changes or if the `.txtpb` changes (assuming shasum to `.txtpb` is
  properly templated in `run_` script). The `run_` script stack should also do nothing when chezmoi state version
  matches version in `.txtpb`. This handles the case where these files may have been changed to handle installations
  for other platforms, but there's no need to run another install on the given machine. i.e. we have an updated `fzf` on
  machine A (linux) and we changed the files to support install on machine B (MacOS) - we don't need to install on A.
- All `run_` scripts like `run_onchange_install-fzf.py` depend on a lib like `chezmoi.py` that will do state handling.
- state managed via https://www.chezmoi.io/reference/commands/state/ i.e. the verions state
- All `run_` scripts like `run_onchange_install-fzf.py` implement a wrapper lib `wrapper.py` that handles the initial
  setup and cleanup when install/upgrade finishes. In reality, the `run_onchange_<installable>.py` mainly holds a
  template comment for chezmoi shasum of `.txtpb` file and appropriate paths to `.txtpb` and any lower-level helper
  scripts.
- All `run_` scripts must depend on the following low-level installer helpers. `install.<format>`, `upgrade.<format>`,
  `uninstall.<format>`. Typically `upgrade` calls `uninstall` then `install`.

<!-- TODO: document plan for upgrade on broken consensus state? -->
<!-- TODO: must document development flow - how to create or destroy state manually for an install? -->
<!-- TODO: I don't have completions for gh CLI -->
<!-- TODO: bump gitconfig from home directory  -->
<!-- TODO: CLI arg parsers https://github.com/Anvil/bash-argsparse ? -->

TODO: things to manage:
- zsh
- fish
- vim - neovim ? What does Dimitar use?
- tree
- bazelisk (large/not-nessary ?)
- buildifier (large/not-nessary ?)
- buildozer (large/not-nessary ?)
- gh (github CLI) (large/not-nessary ?)
- net-tools
- whois
- delve (large/not-nessary ?)
- podman (large/not-nessary ?)
- terraform (large/not-nessary ?)
- nvm (large/not-nessary ?)
- fzf
- fd
- bat
- monaspace fonts https://monaspace.githubnext.com/
- jq
- yq
- wezterm ? Installed on Debian with their provided Debian 12 `.deb`
- monaspace nerd font
- firacode nerd font ?
- starship ? Installed on Debian with their installer script
- zoxide - also need to configure for fish - btw check out integration projects for zoxide, there's even more goodness to add here
- graphviz https://graphviz.org/
 
Things not to manage:
- gcloud (complex!)
- aws CLI (complex!)
- helm (typically avoid using?)
- kubectl (version matters too much depending on environment/context)
- npm, yarn, pnpm, nvm - generally, we don't need this on most systems

# Writing Scripts

Scripts should be careful to check:
- whether the tool already exists on the system at first run (can we?)
- whether the tool is installable on this system
- whether the user WANTS things installed - I think there's a way to give chezmoi ENVs specific
  to scripts or maybe we just read ENVs in general and print helpful outs about it otherwise?
  If a user declines to install a thing, print instructions on running scripts again without
  version changes?
- scripts should be highly verbose. Something like `set -eoux pipefail` in bash scripts.
- all scripts can dry-run ?
- where should we REALLY prefer to put things? I don't think it makes sense for chezmoi to make any non-user-level
  installs i.e. it's against the philosophy of the project to ever make a system-level install. I WANT TO SAY though
  that some of the things I'd like to manage **require** themselves to be system installed. Think `apt` packages.
  There's no way to have a user-space apt package install, right? Surely we don't actually want to do that.

Should only write chezmoi scripts in bash - it's available on every system and can be ported
to Windows (see git bash for windows or that other thing that Bazel does).

Scripts should be written as templates so we can use variables from chezmoi.

Scripts should use chezmoi's partial file tracking? Is that possible? Can our script
compare version against chezmoi state?

<!-- TODO: scripts can be a binary, so may we build a go project here using protoc? -->
<!-- maybe python? probably more easily portable, but not every system has python. -->
<!-- BUT not every system has bash either! Plenty of systems will has dash, ash, etc. -->
<!-- but how to handle sudo? how to handle binary on multiple os/arch? -->
<!-- TODO: can chezmoi templates be python? -->
<!-- TODO: sometimes we will HAVE to call bash like the gh CLI which adds an apt key -->

# Open Questions

- How to version something where system package version is different than other distributions
  of that thing and we might use either one depending on context? Maybe version file
  needs to have some structure and we should use JSONC? Nah, use protobuf and txtpb?
  But how to parse txtpb on CLI? I think there's ACTUALLY a tool for this...
  Or maybe write the scripts in such a way that they don't need the version data? No
  way that would work though because we want things like SHAsums in version files.
  https://protobuf.dev/reference/protobuf/textformat-spec/
- How could bash read textproto files and give us the data we query? We could literally
  parse using bash with something like grep. If it were sufficiently complex, we could
  write and compile multi-platform targets of a go app that reads our specific proto
  message and allow you to query the textproto the way something like `jq` allows.
