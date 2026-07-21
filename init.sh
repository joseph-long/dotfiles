#!/bin/bash
# Usage: curl -OL [...]/raw/init.sh && bash init.sh
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

BASEDIR="${BASEDIR:-$HOME}"
DEVROOT="$BASEDIR/devel"
mkdir -p "$DEVROOT"
cd "$DEVROOT"

if [[ -d dotfiles ]]; then
    cd dotfiles
    git pull
    echo "Updated dotfiles"
else
    git clone https://github.com/joseph-long/dotfiles.git
    echo "Cloned a new copy of dotfiles"
    cd dotfiles
fi
source paths.sh
./setup.sh
