#!/bin/bash
# Usage: curl -OL [...]/raw/setup_workspace.sh && bash setup_workspace.sh
# or: BASEDIR=/groups/jrmales/josephlong bash setup_workspace.sh
source ~/.profile
set -xo pipefail
cd

case "$OSTYPE" in
    darwin*) platform=MacOSX ;;
    linux*) platform=Linux ;;
    *) exit 1 ;;
esac

if [[ $platform == "MacOSX" ]]; then
    xcode-select --install
    if ! [ -x "$(command -v brew)" ]; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    if ! [ -x "$(command -v gs)" ]; then
        brew install ghostscript
    fi
    if ! [ -x "$(command -v code)" ]; then
        brew cask install visual-studio-code
    fi
    if ! [ -e "/Applications/Firefox.app" ]; then
        brew cask install firefox
    fi
    if ! [ -e "/Applications/iTerm.app" ]; then
        brew cask install iterm2
    fi
    if ! [ -e "/Applications/Transmission.app" ]; then
        brew cask install transmission
    fi
    if ! [ -e "/Applications/Slack.app" ]; then
        brew cask install slack
    fi
    if ! [ -e "/Applications/XQuartz.app" ]; then
        brew cask install xquartz
    fi
    if ! [ -d "/Users/$USER/Library/QuickLook/QLStephen.qlgenerator" ]; then
        brew cask install qlstephen
        qlmanage -r
    fi
    if ! [ -d "/Applications/TeX" ]; then
        brew cask install mactex
    fi
    ./setup_macos_01-admin_steps.sh
    ./setup_macos_02-user_steps.sh
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
BASEDIR="${BASEDIR:-$HOME}"
cd $BASEDIR

if [[ ! -e Miniconda3-latest-$platform-x86_64.sh ]]; then
  curl -OL https://repo.continuum.io/miniconda/Miniconda3-latest-$platform-x86_64.sh
fi
chmod +x Miniconda3-latest-$platform-x86_64.sh
if [[ ! -e $BASEDIR/miniconda3 ]]; then
  ./Miniconda3-latest-$platform-x86_64.sh -b -p $BASEDIR/miniconda3 # batch install
fi
if [[ $PATH != *"miniconda3"* ]]; then
  echo "export PATH=\"$BASEDIR/miniconda3/bin:\$PATH\"" >> ~/.profile
fi

# Note: Ubuntu has .profile and .bashrc but no .bash_profile by default
# macOS has neither
source ~/.profile
conda install -y -c conda-forge ipython numpy matplotlib joblib jupyterlab astropy pandas scikit-learn scipy scikit-image photutils ffmpeg pytables
# conda config --add channels "http://ssb.stsci.edu/astroconda"
# conda install -y ds9 poppy

# Based on Linux convention
# https://unix.stackexchange.com/questions/316765/which-distributions-have-home-local-bin-in-path
export PREFIX=$BASEDIR/.local
mkdir -p "$PREFIX/"{lib,include,share,bin}
export DEVROOT="$BASEDIR/devel"
mkdir -p "$DEVROOT"

if [[ $BASEDIR != $HOME ]]; then
    if [[ ! -e $HOME/.local ]]; then
        ln -s $BASEDIR/.local $HOME/.local
    fi
    if [[ ! -e $HOME/devel ]]; then
        ln -s $BASEDIR/devel $HOME/devel
    fi
fi

cd "$DEVROOT"
if [[ -d doodads ]]; then
    cd doodads
    git pull
    echo "Updated doodads"
else
    git clone git@github.com:joseph-long/doodads.git
    echo "Cloned a new copy of doodads"
    cd doodads
fi
pip install -e .
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
./setup_dotfiles.sh
