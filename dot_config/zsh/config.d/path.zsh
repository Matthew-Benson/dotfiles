# load golang bin path
PATH="$HOME/go/bin:$PATH"
PATH="/usr/local/go/bin:$PATH"
export GOPATH="$HOME/go"

# load rust bin path
PATH="$HOME/.cargo/bin:$PATH"

export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# add personal binaries to path
PATH="$HOME/bin":"$PATH"
PATH="$HOME/Applications:$PATH"
PATH="$HOME/.local/bin:$PATH"

# add CLI paths for cloud providers
PATH="/usr/local/google-cloud-sdk/bin:$PATH"

if [ -x "$(command -v pyenv)" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

