#!/usr/bin/env bash
defaultEnv=py313
defaultPyVersion=3.13
source ~/.profile

if [[ ! -e "$BASEDIR/conda" ]]; then
    curl -fsSLo Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
    bash Miniforge3.sh -b -p "$BASEDIR/conda"
fi

"$BASEDIR/conda/bin/conda" init zsh
"$BASEDIR/conda/bin/conda" init bash

if ! conda env list | grep -e '^py313' >/dev/null; then
    mamba create -y -n ${defaultEnv} python=${defaultPyVersion}
fi
if ! grep -e "^conda activate ${defaultEnv}" ~/.profile; then
    echo "conda activate ${defaultEnv}" >> ~/.profile
fi
if ! grep -e "^conda activate ${defaultEnv}" ~/.zshrc; then
    echo "conda activate ${defaultEnv}" >> ~/.zshrc
fi

source ~/.profile

# From here onwards we want to know about any unset vars:
set -u

mamba install -n "${defaultEnv}" -y -c conda-forge \
    ipython numpy matplotlib astropy pandas scipy scikit-image numba \
    jupyterlab notebook ipywidgets nodejs \
    uvloop fsspec pytest flake8 rope black ffmpeg \
    py-spy memory_profiler jupyter-lsp-python \
;

"$BASEDIR/conda/envs/${defaultEnv}/bin/pip" install pyviewarr fitsview jupyterlab-speedy-unfold

# Install editable versions for my packages
source paths.sh
cd "$DEVROOT"

function install_from_github() {
    if [[ -d "$2" ]]; then
        cd "$2"
        git pull
        echo "Updated $2"
    else
        git clone git@github.com:$1/$2.git
        echo "Cloned a new copy of $2"
        cd "$2"
    fi
    pip install -e .
    cd ..
}

install_from_github joseph-long doodads
install_from_github xwcl xconf
