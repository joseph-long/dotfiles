if [[ $(command -v module) == "module" ]]; then
    module load singularity
    module load intel/mkl/64
fi
export PATH="/groups/jrmales/josephlong/.local/bin:$PATH"
export LD_LIBRARY_PATH="/groups/jrmales/josephlong/.local/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="/groups/jrmales/josephlong/.local/lib/pkgconfig:$PKG_CONFIG_PATH"
if command -v srun &> /dev/null; then
    export _UAHPC_SYS=SLURM
elif command -v qstat &> /dev/null; then
    export _UAHPC_SYS=PBS
fi
function myq() {
    if [[ $_UAHPC_SYS == PBS ]]; then
        qstat -w -n -u $USER
    elif [[ $_UAHPC_SYS == SLURM ]]; then
        squeue -u $USER
    fi
}
