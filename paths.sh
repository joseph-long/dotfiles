BASEDIR="${BASEDIR:-$HOME}"
export PREFIX=$BASEDIR/.local
mkdir -p "$PREFIX/"{lib,include,share,bin}
export DEVROOT="$BASEDIR/devel"
mkdir -p "$DEVROOT"

if [[ $BASEDIR != $HOME ]]; then
    if [[ ! -e $HOME/.local ]]; then
        ln -s $BASEDIR/.local $HOME/.local
    fi
    if [[ ! -e $HOME/devel ]]; then
        ln -s $BASEDIR/devel $HOME/devel
    fi
fi
