{ config, lib, pkgs, ... }:
let
  hostName = "Anansi";
in
{
  # Borrowed from https://github.com/LnL7/nix-darwin/blob/master/modules/examples/lnl.nix
  #
  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3;
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;

  system.defaults.dock.autohide = true;
  system.defaults.dock.orientation = "bottom";
  system.defaults.dock.showhidden = true;
  system.defaults.dock.mru-spaces = false;

  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.finder.FXEnableExtensionChangeWarning = false;
  #
  # end

  # Use list view in all Finder windows by default
  # system.defaults.finder.FXPreferredViewStyle = "Nlsv";
  # Disable Resume system-wide
  # system.defaults.NSGlobalDomain.NSQuitAlwaysKeepsWindows = false;
  # Save to disk (not to iCloud) by default
  system.defaults.NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;
  # Disable automatic termination of inactive apps
  # system.defaults.NSGlobalDomain.NSDisableAutomaticTermination = false;
  # Some settings cannot be controlled through Nix (yet)
  system.activationScripts.extraActivation.text = ''
    # Make NetBIOS name (Windows file sharing) consistent with networking.hostName
    defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string ${hostName}
    # Put a lower limit on Bluetooth headphone audio quality
    defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" 40
    # Disable the “Are you sure you want to open this application?” dialog
    defaults write com.apple.LaunchServices LSQuarantine -bool false
    # Disable Resume system-wide
    defaults write WebKitDeveloperExtras -bool true
    # Disable Resume system-wide
    defaults write NSQuitAlwaysKeepsWindows -bool false
    # Disable automatic termination of inactive apps
    defaults write NSDisableAutomaticTermination -bool false
    # -- Finder.app --
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
    # -- Messages.app --
    # Disable smart quotes as it’s annoying for messages that contain code
    defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false
    # Disable automatic spelling corrections
    defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticSpellingCorrectionEnabled" -bool false
    # -- Activity Monitor --
    # Show the main window when launching Activity Monitor
    defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
    # Visualize CPU usage in the Activity Monitor Dock icon
    defaults write com.apple.ActivityMonitor IconType -int 5
    # Show all processes in Activity Monitor
    defaults write com.apple.ActivityMonitor ShowCategory -int 0
    # Sort Activity Monitor results by CPU usage
    defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
    defaults write com.apple.ActivityMonitor SortDirection -int 0
  '';
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ pkgs.nix-repl
      pkgs.git
      pkgs.htop
      pkgs.mosh
      pkgs.texlive.combined.scheme-full
      (pkgs.python36.withPackages(pypkgs: [pypkgs.numpy pypkgs.astropy pypkgs.scipy pypkgs.ipython pypkgs.notebook pypkgs.ipywidgets]))
    ];
  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.bash.enable = true;

  # Configure hostname
  networking.hostName = "Anansi";

  # Recreate /run/current-system symlink after boot.
  services.activate-system.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 2;

  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.maxJobs = 4;
}
