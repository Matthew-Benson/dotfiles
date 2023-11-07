GOOGLE_CLOUD_SDK_PATH="$HOME/.local/google-cloud-sdk"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$GOOGLE_CLOUD_SDK_PATH/path.zsh.inc" ]; then source "$GOOGLE_CLOUD_SDK_PATH/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$GOOGLE_CLOUD_SDK_PATH/completion.zsh.inc" ]; then source "$GOOGLE_CLOUD_SDK_PATH/completion.zsh.inc"; fi
