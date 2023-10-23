#!/bin/bash

# adapted from mathiasbynens/dotfiles .osx — https://mths.be/osx

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v
# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Enable the `locate` command
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist

# Set hostname
default_hostname=$(hostname -s)
read -p "Set hostname [$default_hostname]: " new_hostname
new_hostname=${new_hostname:-$default_hostname}
echo $new_hostname

# Set hostname not to change w/ network:
sudo scutil --set ComputerName "$new_hostname"
sudo scutil --set HostName "$new_hostname"
sudo scutil --set LocalHostName "$new_hostname"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$new_hostname"


# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Disable Spotlight indexing for any volume that gets mounted and has not yet
# been indexed before.
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"


# Load new settings before rebuilding the index
killall mds > /dev/null 2>&1
# Make sure indexing is enabled for the main volume
sudo mdutil -i on / > /dev/null
# Rebuild the index from scratch
sudo mdutil -E / > /dev/null
