#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for dotfile in ".bash_profile" ".bashrc" ".gitconfig" ".git-credential-helper.sh" ".inputrc" ".profile" ".nanorc" ".profile.d" ".slate" ".irssi"; do
    # if it doesn't exist, or exists but is a symlink...
    if ! [ -e "$HOME/$dotfile" ] || [ -h "$HOME/$dotfile" ]; then
        rm -f "$HOME/$dotfile"
        ln -vs "$DIR/$dotfile" "$HOME/$dotfile"
    else
        echo "Already present: $HOME/$dotfile"
    fi
done

# Special case for platform-dependent VSCode config file
if [[ $OSTYPE == darwin* ]]; then
    destpath="$HOME/Library/Application Support/Code/User/settings.json"
else
    destpath="$HOME/.config/Code/User/settings.json"
fi

if ! [ -e "$destpath" ] || [ -h "$destpath" ]; then
    rm -f "$destpath"
    ln -vs "$DIR/vscode-settings.json" "$destpath"
fi
