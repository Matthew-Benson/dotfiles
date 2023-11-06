alias ll="ls -lahG" # this is somewhat standard across installs, but some machines don't define 'll'.

# if podman is installed, alias docker=podman
if command -v podman &> /dev/null; then
    alias docker="podman"
fi
