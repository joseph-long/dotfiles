export CLICOLOR=1
alias grep='grep --color'
export PATH="/Users/jlong/miniconda3/bin:$PATH"
export MXMAKEFILE="/Users/jlong/devel/mxlib/mk/MxApp.mk"
export LD_LIBRARY_PATH="/Users/jlong/.local/lib:/opt/intel/mkl/lib:$LD_LIBRARY_PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/jlong/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/jlong/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/jlong/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/jlong/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

