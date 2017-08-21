#!/bin/bash
UBUNTU_GIT_CREDENTIAL_PATH="/usr/share/doc/git/contrib/credential/gnome-keyring/git-credential-gnome-keyring"
if [ -f $UBUNTU_GIT_CREDENTIAL_PATH ]; then
    $UBUNTU_GIT_CREDENTIAL_PATH $@
elif [ $(command -v git-credential-osxkeychain) ]; then
    git-credential-osxkeychain $@
else
    echo "No git credential helpers found..."
    exit 1
fi
