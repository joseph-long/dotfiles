export PATH="$HOME/bin:/usr/local/bin:$PATH"
export MANPATH="$HOME/share/man:$MANPATH"

if [ $(command -v code) ]; then
    export EDITOR=code
elif [ $(command -v nano) ]; then
    export EDITOR=nano
else
    export EDITOR=vi
fi
export VISUAL=$EDITOR

# color ls output
export CLICOLOR=1
export LSCOLORS=exfxcxdxbxegedabagacad

export XPA_METHOD=local
export HOMEBREW_NO_ANALYTICS=1
