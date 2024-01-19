# User configuration with homemanager

{ config, pkgs, inputs, unstablePkgs, gtkThemeFromScheme, ... }:
  
{
  # Manage user configuration
    imports = [
      inputs.nix-colors.homeManagerModules.default
      inputs.hyprland.homeManagerModules.default
      ../config/waybar.nix
      ../config/swaync.nix
      ../config/neofetch.nix
      ../config/hyprland.nix
      ../config/kitty.nix
      ../config/rofi.nix
      ../config/files.nix
    ];
    
    # Set The Colorscheme
    colorScheme = inputs.nix-colors.colorSchemes.standardized-dark; 
  
    home.packages = with pkgs; [
        android-studio
        baobab
	conky
	discord
	font-awesome
	git
	gitkraken
	gnome.file-roller
	gparted
	grim
	imv
	libnotify
	libvirt
	lm_sensors
	lsd
	neofetch
	noto-fonts-color-emoji
	material-icons
	mpv
	pavucontrol
	pkg-config
	polkit_gnome
	protonup-qt
	rofi-wayland
	slurp
	swaynotificationcenter
	swww
	socat
	symbola
	transmission-gtk
	unigine-superposition
	v4l-utils
	vscodium
	wl-clipboard
	ydotool
	
	# Import Scripts
        (import ../config/scripts/emopicker9000.nix { inherit pkgs; })
        (import ../config/scripts/task-waybar.nix { inherit pkgs; })
        (import ../config/scripts/squirtle.nix { inherit pkgs; })
        (import ../config/scripts/wallsetter.nix { inherit pkgs; })
		
	(lutris.override {
	  extraPkgs = pkgs: [
		wineWowPackages.stable
		winetricks
		jansson
	  ];	 
	})
	
    	unstablePkgs.obsidian
    ];
  
    # Define Settings For Xresources
    xresources.properties = {
      "Xcursor.size" = 24;
    }; 
  
    # Theme GTK
    gtk = {
      enable = true;
      font = {
        name = "Ubuntu";
        size = 12;
        package = pkgs.ubuntu_font_family;
      };
      theme = {
        name = "${config.colorScheme.slug}";
        package = gtkThemeFromScheme {scheme = config.colorScheme;};
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
      };
      gtk3.extraConfig = {
        Settings = ''
        gtk-application-prefer-dark-theme=1
        '';
      };
      gtk4.extraConfig = {
        Settings = ''
        gtk-application-prefer-dark-theme=1
        '';
      };
    };
    
    # Configure Cursor Theme
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    
    # Enable & Configure QT
    qt.enable = true;
    qt.platformTheme = "gtk";
    qt.style.name = "adwaita-dark";
    qt.style.package = pkgs.adwaita-qt;

    # Create XDG Dirs
    xdg = {
      userDirs = {
        enable = true;
        createDirectories = true;
      };
    };
  
    #Set standard applications for file types
    xdg.configFile."mimeapps.list".force = true;
    xdg.mimeApps = {
      enable = true;
      associations.added = {
        "application/pdf" = [ "org.gnome.Evince.desktop" ];
        "image/gif" = [ "org.gnome.Loupe.desktop" ];
        "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
        "image/png" = [ "org.gnome.Loupe.desktop" ];
        "image/*" = [ "org.gnome.Loupe.desktop" ];
        "text/plain" = [ "org.gnome.gedit.desktop" ];
      };
      defaultApplications = {
        "application/pdf" = [ "org.gnome.Evince.desktop" ];
        "image/gif" = [ "org.gnome.Loupe.desktop" ];
        "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
        "image/png" = [ "org.gnome.Loupe.desktop" ];
        "image/*" = [ "org.gnome.Loupe.desktop" ];
        "text/plain" = [ "org.gnome.gedit.desktop" ];
      };
    };
    
    home.sessionVariables = {
      # Make GPU 0 visible for usage with CUDA (see nvidia-smi)
      CUDA_VISIBLE_DEVICES = "0";
      
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
    
    home.file = {
      # Set background image
      ".config/background.jpg".source = ../config/files/media/wallpapers/background01.jpg;
      
      # Get rev and hashes for fetchgit: nix-prefetch-git  https://github.com/xxx/yyy.git
      # ".config/repos/nixified-ai".source = pkgs.fetchgit {
      #  url = "https://github.com/nixified-ai/flake.git";
      #  rev = "63339e4c8727578a0fe0f2c63865f60b6e800079";
      #  sha256 = "0l44n8ny314lybv5d3fmkj6ra86p7r7664ql2qbg471gcn5d53sq";
      # };
    };
    
    # Enable Syncthing
    services.syncthing = {
      enable = true;
    };
    
    # Home Manager Settings
    home.username = "hyprflo";
    home.homeDirectory = "/home/hyprflo";
    
    /* The home.stateVersion option does not have a default and must be set equal to your Nix-Channel-Version */
    home.stateVersion = "23.11";
    
    # Let Home Manager install and manage your shell (for e.g. environment variables)
    programs.fish.enable = true;
    
    # Allow Home Manager to manage itself
    programs.home-manager.enable = true;
}
