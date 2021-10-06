#!/usr/bin/env bash
source ~/.profile
if ! conda env list | grep -e '^py39' >/dev/null; then
    conda create -y -n py39 python=3.9
    
fi
if ! grep -e '^conda activate py39' ~/.profile; then
    echo "conda activate py39" >> ~/.profile
fi
source ~/.profile
conda install -y -c conda-forge \
    ipython numpy matplotlib astropy pandas scikit-learn scipy scikit-image numba \
    jupyterlab ipywidgets nodejs \
    mkl mkl-include \
    dask distributed uvloop dask-labextension fsspec graphviz python-graphviz \
    asyncssh pytest flake8 rope black ffmpeg \
    py-spy memory_profiler

source paths.sh
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
