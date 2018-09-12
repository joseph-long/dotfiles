if [ $(command -v code) ]; then
    export EDITOR="code -w"
elif [ $(command -v nano) ]; then
    export EDITOR=nano
else
    export EDITOR=vi
fi
export VISUAL=$EDITOR