#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for dotfile in ".gitconfig" ".git-credential-helper.sh" ".inputrc" ".nanorc" ".profile.d" ".slate" ".irssi" ".pylintrc"; do
    # if it doesn't exist, or exists but is a symlink...
    if ! [ -e "$HOME/$dotfile" ] || [ -h "$HOME/$dotfile" ]; then
        rm -f "$HOME/$dotfile"
        ln -vs "$DIR/$dotfile" "$HOME/$dotfile"
    else
        echo "Already present: $HOME/$dotfile"
    fi
done

if ! grep -Fq ".profile.d" ~/.profile; then
    echo "Appending source lines to .profile"
    echo "for fn in ~/.profile.d/*.sh; do source "\$fn"; done" >> ~/.profile
    touch ~/.profile.d/per-host/$(hostname -s).sh
    echo "source ~/.profile.d/per-host/$(hostname -s).sh" >> ~/.profile
else
    echo "~/.profile.d is already mentioned in .profile, not adding source lines"
fi


# Special case for platform-dependent VSCode config file
if [[ $OSTYPE == darwin* ]]; then
    destpath="$HOME/Library/Application Support/Code/User/settings.json"
else
    destpath="$HOME/.config/Code/User/settings.json"
fi

if ! [ -e "$destpath" ] || [ -h "$destpath" ]; then
    mkdir -p "$(dirname "$destpath")"
    rm -f "$destpath"
    ln -vs "$DIR/vscode-settings.json" "$destpath"
fi
