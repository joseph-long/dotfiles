#!/bin/bash
# Usage: bash setup.sh
#    or: BASEDIR=/mnt/home/jlong bash setup.sh
source ~/.profile
set -xo pipefail
OSTYPE=$(uname)

case "$OSTYPE" in
    Darwin) platform=MacOSX ;;
    Linux) platform=Linux ;;
    *) exit 1 ;;
esac

# Based on Linux convention
# https://unix.stackexchange.com/questions/316765/which-distributions-have-home-local-bin-in-path
source paths.sh
cd $BASEDIR
bash setup_scripts/link_dotfiles.sh

if [[ $platform == "MacOSX" ]]; then
    bash setup_scripts/macos.sh
fi

bash setup_scripts/setup_python.sh
