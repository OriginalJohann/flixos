# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:

let
  monitorsXmlContent = builtins.readFile ./config/monitors.xml;
  monitorsConfig = pkgs.writeText "gdm_monitors.xml" monitorsXmlContent;
in
{
  imports = [ 
    # Include the results of the hardware scan
    ./hardware-configuration.nix
        
    # Include systempackages meant to be installed
    ./systempackages.nix
    
    # Include users that will be added
    ./users.nix
  ];

  # Enable experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    useOSProber = true;
    efiSupport = true;
  };
  
  # Enable ntfs-drives
  boot.supportedFilesystems = [ "ntfs" ];
 
  # Define your hostname.
  networking.hostName = "flixos";
  
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services.xserver = {
    # Enable the X11 windowing system
    enable = true;
    
    # Enable the GNOME desktop environment and set as default
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    desktopManager.gnome.enable = true;
    displayManager.defaultSession = "gnome";
    
    # Configure keymap in X11
    layout = "de";
    xkbVariant = "";
    
    # Tell Xorg to use nvidia driver
    videoDrivers = [ "nvidia" ];
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents
  services.printing = {
    enable = true;
    drivers = [ pkgs.canon-cups-ufr2 pkgs.carps-cups pkgs.gutenprintBin ]; # All Canon-drivers
    browsing = true;
  };
  # Enable printer autodetect
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };
  # Enable scanning (user needs scanner and/or lp group)
  hardware.sane = {
    enable = true; # scanimage -L
    extraBackends = [ pkgs.sane-airscan ]; # https://support.apple.com/en-us/HT201311
  };

  environment.sessionVariables = {
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL="1";
    
    # Prevent instant log-out after login on wayland
    MUTTER_DEBUG_KMS_THREAD_TYPE="user";
    
    WLR_NO_HARDWARE_CURSORS = "1";
    
    POLKIT_BIN = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  };

  # Enable sound with pulseaudio
  sound.enable = true;
  hardware.pulseaudio.enable = true; 

  # Make sure opengl is enabled
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Activate https://nixos.wiki/wiki/Polkit
  security.polkit.enable = true;
  
  nixpkgs.config = {
    # Allow unfree packages
    allowUnfree = true;
  };
  
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (builtins.parseDrvName pkg.name).name [
      "nvidia-x11"
      "steam"
      "steam-original"
      "steam-run"
  ];
  
  hardware.nvidia = {
    # Modsetting is needed for most wayland compositors
    modesetting.enable = true;

    # Use the open source version of the kernel module
    open = true;

    # Enable the nvidia settings menu
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enable flatpak
  # flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  services.flatpak.enable = true;

  # gnome services enabled
  services.udev.packages = with pkgs; [ 
    gnome.gnome-settings-daemon 
  ];

  # Allow steam-connections
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    package = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        ncurses6
        mangohud
        
        # Fix missing X-symbols
        keyutils
        libgdiplus
        libkrb5
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        
        # Other potentially missing packages
        gtk3
        gtk3-x11
        mono
        zlib
      ];
    };
  };
  
  # Enable hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  
  # Enable gamemode
  programs.gamemode.enable = true;
  
  # Enable java
  programs.java.enable = true;
  
  # Enable xdg-portals
  xdg.portal.enable = true;

  systemd.tmpfiles.rules = [
    # Fix wrong login screen (rebuild after settings changed in configs)
    "L+ /run/gdm/.config/monitors.xml - - - - ${monitorsConfig}"
	
    # Set access permissions for data-directory
    "Z /data 775 root data"
  ];
  
  # Enable gsconnect/KDE connect ports
  networking.firewall.allowedTCPPortRanges = [
    { from = 1714; to = 1764; }
  ];
  networking.firewall.allowedUDPPortRanges = [
    { from = 1714; to = 1764; }
  ];
  
  # Automatic store optimization
  nix.optimise.automatic = true;
  
  # Allow nixified ai's substituters
  #nix.settings.trusted-substituters = [ "https://ai.cachix.org" "https://hyprland.cachix.org" ];
  #nix.settings.trusted-public-keys = [ "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc=" "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];

  # Copy NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuraiotn.nix)
  #system.copySystemConfiguration = true;
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-23.11";
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
