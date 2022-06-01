#!/usr/bin/env bash
source ~/.profile
if ! conda env list | grep -e '^py39' >/dev/null; then
    mamba create -y -n py39 python=3.9
    
fi
if ! grep -e '^conda activate py39' ~/.profile; then
    echo "conda activate py39" >> ~/.profile
fi
if ! grep -e '^conda activate py39' ~/.zshrc; then
    echo "conda activate py39" >> ~/.zshrc
fi
source ~/.profile
if [[ $(uname -p) == "x86_64" ]]; then
    mamba install -y mkl mkl-include
fi
mamba install -n py39 -y -c conda-forge \
    ipython numpy matplotlib astropy pandas scipy scikit-image numba \
    jupyterlab notebook ipywidgets nodejs \
    dask uvloop fsspec graphviz python-graphviz \
    asyncssh pytest flake8 rope black ffmpeg \
    py-spy memory_profiler
pip install 'ray[default]'

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
install_from_github xwcl irods_fsspec
install_from_github xwcl xconf
install_from_github xwcl xpipeline
