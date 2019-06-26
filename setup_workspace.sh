#!/bin/bash
# Usage: curl -OL [...]/raw/setup_workspace.sh && bash setup_workspace.sh
set -xuo pipefail
cd
source ~/.profile

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

if [[ ! -e Miniconda3-latest-$platform-x86_64.sh ]]; then
  curl -OL https://repo.continuum.io/miniconda/Miniconda3-latest-$platform-x86_64.sh
fi
chmod +x Miniconda3-latest-$platform-x86_64.sh
if [[ ! -e miniconda3 ]]; then
  ./Miniconda3-latest-$platform-x86_64.sh -b  # batch install
fi
if [[ $PATH != *"miniconda3"* ]]; then
  echo "export PATH=\"$HOME/miniconda3/bin:\$PATH\"" >> ~/.profile
fi

# Note: Ubuntu has .profile and .bashrc but no .bash_profile by default
# macOS has neither
source ~/.profile
conda install -y -c conda-forge ipython numpy matplotlib joblib jupyterlab astropy pandas scikit-learn scipy scikit-image photutils ffmpeg pytables
conda config --add channels "http://ssb.stsci.edu/astroconda"
conda install -y ds9 poppy

# Based on Linux convention
# https://unix.stackexchange.com/questions/316765/which-distributions-have-home-local-bin-in-path
export PREFIX=$HOME/.local
mkdir -p "$PREFIX/"{lib,include,share,bin}
export DEVROOT="$HOME/devel"
mkdir -p "$DEVROOT"
cd "$DEVROOT"
# Intel MKL
if [[ $platform == "Linux" ]]; then
    INTEL_MKL_VERSION="2019.0.117"
    INTEL_MKL_DIR="l_mkl_$INTEL_MKL_VERSION"
    if [[ ! -d "./$INTEL_MKL_DIR" ]]; then
    curl -OL http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/13575/$INTEL_MKL_DIR.tgz
    tar xvzf $INTEL_MKL_DIR.tgz
    fi
    if [[ ! -d "/opt/intel" ]]; then
    cd $INTEL_MKL_DIR/
    curl -OL https://raw.githubusercontent.com/magao-x/MagAOX/master/setup/intel_mkl_silent_install.cfg
    sudo ./install.sh -s intel_mkl_silent_install.cfg
    fi
fi
#
# mxLib Dependencies
#
SOFA_REV="2018_0130_C"
SOFA_REV_DATE=$(echo $SOFA_REV | tr -d _C)
EIGEN_VERSION="3.3.4"
LEVMAR_VERSION="2.6"
FFTW_VERSION="3.3.8"
# yum -y install lapack-devel atlas-devel
# yum -y install boost-devel
# yum -y install gsl gsl-devel
#
# FFTW (note: need 3.3.8 or newer, so can't use yum)
#
if [[ ! -d "./fftw-$FFTW_VERSION" ]]; then
    curl -OL http://fftw.org/fftw-$FFTW_VERSION.tar.gz
    tar xzf fftw-$FFTW_VERSION.tar.gz
fi
cd fftw-$FFTW_VERSION
# Following Jared's comprehensive build script: https://gist.github.com/jaredmales/0aacc00b0ce493cd63d3c5c75ccc6cdd
if [ ! -e /usr/local/lib/libfftw3f.a ]; then
    ./configure --prefix=$PREFIX --enable-float --with-combined-threads --enable-threads --enable-shared
    make
    make install
fi
if [ ! -e /usr/local/lib/libfftw3.a ]; then
    ./configure --prefix=$PREFIX --with-combined-threads --enable-threads --enable-shared
    make
    make install
fi
if [ ! -e /usr/local/lib/libfftw3l.a ]; then
    ./configure --prefix=$PREFIX --enable-long-double --with-combined-threads --enable-threads --enable-shared
    make
    make install
fi
if [ ! -e /usr/local/lib/libfftw3q.a ]; then
    ./configure --prefix=$PREFIX --enable-quad-precision --with-combined-threads --enable-threads --enable-shared
    make
    make install
fi
cd "$DEVROOT"
#
# CFITSIO
#
if [[ ! -d ./cfitsio ]]; then
    curl -OL http://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio_latest.tar.gz
    tar xzf cfitsio_latest.tar.gz
fi
cd cfitsio
./configure --prefix="$PREFIX"
make
make install
cd "$DEVROOT"
#
# SOFA
#
if [[ ! -d ./sofa ]]; then
    curl http://www.iausofa.org/$SOFA_REV/sofa_c-$SOFA_REV_DATE.tar.gz | tar xvz
    echo "Downloaded and unpacked 'sofa' from sofa_c_-$SOFA_REV_DATE.tar.gz"
fi
cd sofa/$SOFA_REV_DATE/c/src
make "CFLAGX=-pedantic -Wall -W -O -fPIC" "CFLAGF=-c -pedantic -Wall -W -O -fPIC"
make install "INSTALL_DIR=$PREFIX"
cd "$DEVROOT"
#
# Eigen
#
if [[ ! -e $(readlink "$PREFIX/include/Eigen") ]]; then
    curl -L http://bitbucket.org/eigen/eigen/get/$EIGEN_VERSION.tar.gz | tar xvz
    EIGEN_DIR=$(realpath $(find . -type d -name "eigen-eigen-*" | head -n 1))
    ln -sv "$EIGEN_DIR/Eigen" "$PREFIX/include/Eigen"
    echo "$PREFIX/include/Eigen is now a symlink to $EIGEN_DIR"
fi
cd "$DEVROOT"
#
# LevMar
#
LEVMAR_DIR="./levmar-$LEVMAR_VERSION"
if [[ ! -d $LEVMAR_DIR ]]; then
    curl -LA "Mozilla/5.0" http://users.ics.forth.gr/~lourakis/levmar/levmar-$LEVMAR_VERSION.tgz | tar xvz
fi
cd $LEVMAR_DIR
make liblevmar.a
install liblevmar.a "$PREFIX/lib/"
cd "$DEVROOT"

# Test SSH to Github:
if ! ssh -T git@github.com; then
    echo "Looks like SSH to GitHub isn't set up yet..."
    exit 1
fi

if [[ -d "$DEVROOT/mxlib" ]]; then
    cd "$DEVROOT/mxlib"
    git pull
    echo "Updated mxlib"
else
    git clone --depth=1 https://github.com/jaredmales/mxlib.git
    echo "Cloned a new copy of mxlib"
    git remote add jlong git@github.com:joseph-long/mxlib.git
    cd "$DEVROOT/mxlib"
fi
set +u
if [[ $MXMAKEFILE != "$DEVROOT/mxlib/mk/MxApp.mk" ]]; then
  export MXMAKEFILE="$DEVROOT/mxlib/mk/MxApp.mk"
  echo "export MXMAKEFILE=\"$DEVROOT/mxlib/mk/MxApp.mk\"" >> ~/.profile
fi
set -u
make "PREFIX=$PREFIX"
make install "PREFIX=$PREFIX"
if [[ $LD_LIBRARY_PATH != *"$PREFIX/lib"* ]]; then
    if [[ $platform == "Linux" ]]; then
        echo "export LD_LIBRARY_PATH=\"$PREFIX/lib:/opt/intel/mkl/lib/intel64:\$LD_LIBRARY_PATH\"" >> ~/.profile
    elif [[ $platform == "MacOSX" ]]; then
        echo "export LD_LIBRARY_PATH=\"$PREFIX/lib:/opt/intel/mkl/lib:\$LD_LIBRARY_PATH\"" >> ~/.profile
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