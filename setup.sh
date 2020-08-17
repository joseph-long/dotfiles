#!/bin/bash
# Usage: curl -OL [...]/raw/setup.sh && bash setup.sh
if [[ -e ~/.profile ]]; then
    source ~/.profile
fi
set -xuo pipefail
cd

case "$OSTYPE" in
    darwin*) platform=MacOSX ;;
    linux*) platform=Linux ;;
    *) exit 1 ;;
esac

if ! [ -x "$(command -v git)" ]; then
    if [[ $platform == "MacOSX" ]]; then
        xcode-select --install
    else
        echo "git command unavailable; install it first"
        exit 1
    fi
fi

export DEVROOT="$HOME/devel"
mkdir -p "$DEVROOT"

cd "$DEVROOT"

if [[ -d dotfiles ]]; then
    cd dotfiles
    git pull
    echo "Updated dotfiles"
else
    git clone git@github.com:joseph-long/dotfiles.git
    echo "Cloned a new copy of dotfiles"
    cd dotfiles
fi
./setup_workspace.sh