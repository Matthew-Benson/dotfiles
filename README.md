# dotfiles
Personal dotfiles configurations for Linux, MacOS, and Windows for terminals and other configurables.

To bring this configuration to a new system, use chezmoi 

```sh
sh -c "$(curl -fsLs git.io/chezmoi)" -- init --apply matthew-benson
```

or Windows

```powershell
# To install in ./bin
(iwr -UseBasicParsing https://git.io/chezmoi.ps1).Content | powershell -c -

# To install in another location
'$params = "-BinDir ~/other"', (iwr https://git.io/chezmoi.ps1).Content | powershell -c -

# For information about other options, run
'$params = "-?"', (iwr https://git.io/chezmoi.ps1).Content | powershell -c -
```

See https://www.chezmoi.io/docs/install/

## Linux/MacOS ZSH Theme

### Fonts

Install meslo-nerd and configure for Linux/MacOS:

https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k

Plugins and oh-my-zsh are managed by chezmoi, but versions for releases in the config may need updated from time to time.

### Dependencies

Install fzf and fd to find/search with hotkeys and good default file ignores

https://github.com/junegunn/fzf

https://github.com/sharkdp/fd

# TODO: vimrc
