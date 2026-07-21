#!/usr/bin/env bash
thisDir=$(exec 2>/dev/null;cd -- $(dirname "$0"); unset PWD; /usr/bin/pwd || /bin/pwd || pwd)
DIR=$(realpath $thisDir/..)
mkdir -p "$HOME/.ssh"
for dotfile in ".gitconfig" ".git-credential-helper.sh" ".inputrc" ".nanorc" ".profile.d" ".pylintrc" ".ssh/config" ".jupyter"; do
    # if it doesn't exist, or exists but is a symlink...
    if ! [ -e "$HOME/$dotfile" ] || [ -h "$HOME/$dotfile" ]; then
        rm -f "$HOME/$dotfile"
        ln -vs "$DIR/$dotfile" "$HOME/$dotfile"
    else
        echo "Already present: $HOME/$dotfile"
    fi
done

mkdir -p ~/.ipython/profile_default/startup/
ln -vfs "$DIR/.ipython/profile_default/startup/00-init.ipy" ~/.ipython/profile_default/startup/00-init.ipy

if ! grep -Fq ".profile.d" ~/.profile; then
    echo "Appending source lines to .profile"
    touch ~/.profile
    echo "for fn in ~/.profile.d/*.sh; do source "\$fn"; done" >> ~/.profile
    touch ~/.profile.d/per-host/$(hostname -s).sh
    echo "source ~/.profile.d/per-host/$(hostname -s).sh" >> ~/.profile
else
    echo "~/.profile.d is already mentioned in .profile, not adding source lines"
fi

# Why does this have to be named .zshrc to get colors to work? :(
if ! grep -Fq ".profile.d" ~/.zshrc; then
    touch ~/.zshrc
    echo "Appending source lines to .zshrc"
    echo "for fn in ~/.profile.d/*.zsh; do source "\$fn"; done" >> ~/.zshrc
    touch ~/.profile.d/per-host/$(hostname -s).zsh
    echo "source ~/.profile.d/per-host/$(hostname -s).zsh" >> ~/.zshrc
else
    echo "~/.profile.d is already mentioned in .zshrc, not adding source lines"
fi

# Special case for platform-dependent VSCode config file
if [[ $OSTYPE == darwin* ]]; then
    destpath="$HOME/Library/Application Support/Code/User/settings.json"
else
    destpath="$HOME/.config/Code/User/settings.json"
fi

if ! [[ -e "$destpath" ]]; then
    mkdir -p "$(dirname "$destpath")"
    cp "$DIR/.vscode/settings.json" "$destpath"
fi
