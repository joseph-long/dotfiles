# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  tiddlywiki = import ./custom-packages/tiddlywiki.nix;
in
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
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

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

  # Enable the locate command
  services.locate.enable = true;

  # Enable nginx
  services.nginx.enable = true;
  services.nginx.httpConfig = ''
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    gzip on;
    gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;
    gzip_disable "msie6";
    default_type application/octet-stream;

    server {
      listen 80 default_server;
      listen [::]:80 default_server ipv6only=on;

      root /srv/www;
      index index.html index.htm;

      server_name joseph-long.com www.joseph-long.com localhost;
    }
  '';
  system.activationScripts.webserver = ''
    mkdir -p /srv/www
    chown ${config.services.nginx.user}:${config.services.nginx.group} /srv/www
    chmod u=rwx,g=rwsx,o=rx /srv/www
  '';
  systemd.services.tiddlywiki = {
    description = "Single-user TiddlyWiki server";
    # Start the service after the network is available
    after = [ "network.target" ];
    preStart = ''
     mkdir -p /srv/tiddlywiki
     if ! [ -e /srv/tiddlywiki/tiddlywiki.info ]; then
        ${tiddlywiki}/bin/tiddlywiki /srv/tiddlywiki --init server
     fi
     chmod -R u=rwx,g=rwsx,o=rx /srv/tiddlywiki
     chown -R ${config.services.nginx.user}:${config.services.nginx.group} /srv/tiddlywiki
    '';
    # We're going to run it on port 8080 in production
    environment = { PORT = "8080"; };
    serviceConfig = {
      PermissionsStartOnly = true;
      # The actual command to run
      ExecStart = ''${tiddlywiki}/bin/tiddlywiki /srv/tiddlywiki --server 8080 "\$:/core/save/all" text/plain text/html uname pass 107.191.41.74'';
      # ExecStart = ''${pkgs.python3}/bin/python3 -m http.server'';
      # For security reasons we'll run this process as a special 'nodejs' user
      User = config.services.nginx.user;
      Group = config.services.nginx.group;
      Restart = "always";
    };
  };


  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.josephoenix = {
    isNormalUser = true;
    initialPassword = "nixpassword1";
    description = "Joseph Long";
    extraGroups = ["wheel" config.services.nginx.group ];
    uid = 1000;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "15.09";

  # Enable automatic garbage collection
  nix.gc.automatic = true;
  nix.gc.dates = "03:15";

}
