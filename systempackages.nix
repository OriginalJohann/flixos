# Use this file for managing packages on system level

{ config, pkgs, ... }:

let
  #unstable = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  #unstablePkgs = import unstable { 
  #  config.allowUnfree = true; 
  #};
in
{
  # Enable insecure packages (dependencies of older packages)
  nixpkgs.config.permittedInsecurePackages = [
    "mailspring-1.12.0"
  ];

  # Exclude all GNOME packages
  services.gnome.core-utilities.enable = false;
  
  # Enable shells for using
  programs.gnome-terminal.enable = true;
  programs.fish.enable = true;
  
  # Add fish-shell to environment.
  environment.shells = with pkgs; [ fish ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  	bitwarden
  	evince
  	firefox
  	flatpak
  	gcolor3
  	gimp
  	gnome.gedit
  	gnome.gnome-themes-extra
  	gnome.gnome-tweaks
  	gnome.nautilus
  	gnome.simple-scan
  	gnomeExtensions.app-icons-taskbar
  	gnomeExtensions.appindicator
  	gnomeExtensions.gsconnect
  	gnomeExtensions.no-overview
  	gnomeExtensions.tiling-assistant
  	gnomeExtensions.user-themes
  	hunspell
  	hunspellDicts.de_DE
  	hunspellDicts.en_US
  	libreoffice-qt
  	loupe
  	nssmdns
  	sane-backends
  	thunderbird
  	unzip
  	vim
  	vlc
	wget
	
	#unstablePkgs.bitwarden
  	
  	# Override udev-config for parallel printing and scanning
        # https://github.com/NixOS/nixpkgs/issues/147217#issuecomment-1214130697
  	(sane-backends.overrideAttrs (oldAttrs: rec {
          postInstall = builtins.replaceStrings
          	["./tools/sane-desc -m udev"]
          	["./tools/sane-desc -m udev+hwdb -s doc/descriptions:doc/descriptions-external"]
          oldAttrs.postInstall;
        }))
     
        # For debugging remove commands and rebuild-switch
        # gnome.gnome-shell
  	# gnome.mutter
 	# gnome.gnome-session
  	# glib
  	# gjs
  	# spidermonkey_102
  ];

  # For debugging purposes -> environment.enableDebugInfo = true;
}
