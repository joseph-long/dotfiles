# macOS specific steps
thisDir=$(exec 2>/dev/null;cd -- $(dirname "$0"); unset PWD; /usr/bin/pwd || /bin/pwd || pwd)

if [ -e "$HOME/.zprofile" ]; then
    source "$HOME/.zprofile"
fi
if ! [ -x "$(command -v brew)" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo >> "$HOME/.zshrc"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> "$HOME/.zshrc"
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
fi
if ! [ -e "/Applications/Signal.app" ]; then
    brew install --cask signal
fi
if ! [ -e "/Applications/Firefox.app" ]; then
    brew install --cask firefox
fi
if ! [ -e "/Applications/Slack.app" ]; then
    brew install --cask slack
fi
if ! [ -e "/Applications/VSCodium.app" ]; then
    brew install --cask vscodium
fi
if ! [ -e "/Applications/Utilities/XQuartz.app" ]; then
    brew install --cask xquartz
fi
if ! [ -d "/Applications/TeX" ]; then
    brew install --cask mactex
fi
if ! [ -e "/Applications/zoom.us.app" ]; then
    brew install --cask zoom
fi
if ! [ -e "/Applications/Rectangle.app" ]; then
    brew install --cask rectangle
fi
if ! [ -e "/Applications/Zed.app" ]; then
    brew install --cask zed
fi
if ! command -v fzf 2>&1 > /dev/null; then
    brew install fzf
fi

# ***** Finder *****
# Settings > advanced > show all filename extensions
defaults write .GlobalPreferences AppleShowAllExtensions -bool true
# Settings > advanced > show warning before changing an extension: false
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# View > as list
defaults write com.apple.finder FXPreferredViewStyle -string "nlsv"
# View > show path bar
defaults write com.apple.finder ShowPathbar -bool true
# View > show status bar
defaults write com.apple.finder ShowStatusBar -bool true
# Show all hidden files (cmd+shift+.)
defaults write com.apple.finder AppleShowAllFiles true

# Set Desktop as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Show the ~/Library folder
chflags nohidden ~/Library

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
   	General -bool true \
   	OpenWith -bool true \
   	Privileges -bool true

# Stop iTunes from responding to the keyboard media keys
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0
# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

sudo bash $thisDir/sudo_macos.sh
