# TODO: migrate me to chezmoi templates

# MacOS Specific config
if [[ $OSTYPE == darwin* ]]; then
  bindkey "ç" fzf-cd-widget # bind "ALT-C" for MacOS fzf
  PATH="$HOME/Library/Python/3.7/bin:${PATH}" # python 3 packages from pip are here
  PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:${PATH}"

  # add mysql command line utilities from MySQL Workbench
  PATH=$PATH:/Applications/MySQLWorkbench.app/Contents/MacOS

  # add cmake to path - this was installed via dmg from their downloads
  PATH="/Applications/CMake.app/Contents/bin":"$PATH"

  # add personal snippets to path
  PATH="$HOME/Projects/snippets":"$PATH"

  alias pip="/usr/bin/pip3"

  # https://www.jenv.be/
  # load jenv path for java version management
  PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"
  # NOTE: added AdoptOpenJDK 8 to jenv
fi
