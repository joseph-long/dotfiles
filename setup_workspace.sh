#!/bin/bash
# Usage: curl -OL [...]/raw/setup_workspace.sh && bash setup_workspace.sh
# or: BASEDIR=/groups/jrmales/josephlong bash setup_workspace.sh
source ~/.profile
set -xo pipefail
# cd
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
./setup_dotfiles.sh

if [[ $platform == "MacOSX" ]]; then
    if ! [ -x "$(command -v brew)" ]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi
    if ! [ -x "$(command -v code)" ]; then
        brew install --cask signal
    fi
    if ! [ -x "$(command -v code)" ]; then
        brew install --cask visual-studio-code
    fi
    if ! [ -e "/Applications/Firefox.app" ]; then
        brew install --cask firefox
    fi
    if ! [ -e "/Applications/iTerm.app" ]; then
        brew install --cask iterm2
    fi
    if ! [ -e "/Applications/Transmission.app" ]; then
        brew install --cask transmission
    fi
    if ! [ -e "/Applications/Slack.app" ]; then
        brew install --cask slack
    fi
    if ! [ -e "/Applications/Utilities/XQuartz.app" ]; then
        brew install --cask xquartz
    fi
    if ! [ -e "/Applications/Spotify.app" ]; then
        brew install --cask spotify
    fi
    if ! [ -d "/Applications/TeX" ]; then
        brew install --cask mactex
    fi
    if ! [ -e "/Applications/Zoom.app" ]; then
        brew install --cask zoom
    fi
fi
if [[ $platform == "Linux" && ${XDG_SESSION_TYPE:-0} == x11 ]]; then
    cd Downloads
    # Vagrant
    if ! [ -x "$(command -v vagrant)" ]; then
        curl -OL https://releases.hashicorp.com/vagrant/2.2.5/vagrant_2.2.5_x86_64.deb
        sudo dpkg -i vagrant_2.2.5_x86_64.deb
    fi
    # Slack
    if ! [ -x "$(command -v slack)" ]; then
        curl -OL https://downloads.slack-edge.com/linux_releases/slack-desktop-4.0.1-amd64.deb
        sudo dpkg -i slack-desktop-4.0.1-amd64.deb
        sudo apt --fix-broken install -y
    fi
    # VSCode
    if ! [ -x "$(command -v code)" ]; then
        curl -L https://go.microsoft.com/fwlink/?LinkID=760868 > vscode.deb
        sudo dpkg -i vscode.deb
    fi
    # Spotify
    if ! [ -x "$(command -v spotify)" ]; then
        curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
        echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
        sudo apt-get update
        sudo apt-get install -y spotify-client
    fi
    # Docker
    if ! [ -x "$(command -v docker)" ]; then
        sudo apt-get install -y \
            apt-transport-https \
            ca-certificates \
            curl \
            gnupg-agent \
            software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository \
            "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
            $(lsb_release -cs) \
            stable"
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    fi
    # yarn
    if ! [ -x "$(command -v yarn)" ]; then
        curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
        echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
        sudo apt-get update && sudo apt-get install -y yarn
    fi
    cd
fi

if [[ ! -e $BASEDIR/mambaforge ]]; then
    curl -L -O https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh
    bash Mambaforge-$(uname)-$(uname -m).sh -b -p $BASEDIR/mambaforge
fi
$BASEDIR/mambaforge/bin/conda init zsh
$BASEDIR/mambaforge/bin/conda init bash
