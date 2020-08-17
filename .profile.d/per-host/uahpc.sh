if [[ $(command -v module) == "module" ]]; then
    module load singularity
    module load intel/mkl/64
fi
export PATH="/groups/jrmales/josephlong/.local/bin:$PATH"
export LD_LIBRARY_PATH="/groups/jrmales/josephlong/.local/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="/groups/jrmales/josephlong/.local/lib/pkgconfig:$PKG_CONFIG_PATH"
alias myq="qstat -w -n -u josephlong"
