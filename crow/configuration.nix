# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "crow"; # Define your hostname.
  networking.firewall.allowedTCPPorts = [ 80 443 8000 8080 ];
  networking.firewall.allowedUDPPortRanges = [ { from = 60000; to = 61000; } ];

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    nginx
    irssi
    git
    vim
    screen
    mosh
    fail2ban
    gcc
    gnumake 
    python3
    nodejs
    tiddlywiki
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";
  services.openssh.passwordAuthentication = false;

  # Enable the locate command
  services.locate.enable = true;

  # Enable nginx
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."joseph-long.com" = {
      serverAliases = [ "www.joseph-long.com" ];
      enableACME = true;
      forceSSL = false;
    };
  };

  # Define a user account.
  users.extraUsers.josephoenix = {
    isNormalUser = true;
    initialPassword = "nixpassword1";
    description = "Joseph Long";
    extraGroups = ["wheel" config.services.nginx.group ];
    uid = 1000;
    openssh.authorizedKeys.keys = [ "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBKNIvEp1lQtDihZaxeAOAnH/rP1LRHyHCG6KEOUs+RGWqOVVlW+aN0iGvdXs9IQsArkN224w5DpsOyEduda+6NU= jdl@Anansi" ];
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "15.09";

  # Enable automatic garbage collection
  nix.gc.automatic = true;
  nix.gc.dates = "03:15";
}
