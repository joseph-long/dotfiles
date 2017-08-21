#!/bin/bash

# adapted from mathiasbynens/dotfiles .osx — https://mths.be/osx

# Ask for the administrator password upfront
sudo -v
# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Enable the `locate` command
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist
default_hostname=Anansi

read -p "Set hostname [$default_hostname]: " new_hostname
new_hostname=${new_hostname:-$default_hostname}
echo $new_hostname

# Set hostname not to change w/ network:
sudo scutil --set HostName $new_hostname
sudo scutil --set ComputerName $new_hostname
sudo scutil --set HostName $new_hostname
sudo scutil --set LocalHostName $new_hostname
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $new_hostname

# Disable local Time Machine snapshots
sudo tmutil disablelocal

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
bash $DIR/setup_osx_nosudo.sh
