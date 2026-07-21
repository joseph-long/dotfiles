# Added by icommands 4.1.9 CyVerse Installer on
# On Wed Oct  7 16:24:10 MST 2020
export PATH="/Applications/icommands/:$PATH"
# Adding plugin path for older Mac OS X systems
export IRODS_PLUGINS_HOME=/Applications/icommands/plugins/
source /Applications/icommands/i-commands-auto.bash

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/josephlong/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/josephlong/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/josephlong/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/josephlong/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
