# User configuration with homemanager

{ config, pkgs, inputs, unstablePkgs, gtkThemeFromScheme, ... }:
  
{
  # Manage user configuration
  home.packages = with pkgs; [
      android-studio
      baobab
      conky
      discord
      git
      gitkraken
      gnomeExtensions.gamemode-indicator-in-system-settings
      gnomeExtensions.syncthing-indicator
      gnomeExtensions.vitals
      gparted
      protonup-qt
      neofetch
      unigine-superposition
      vscodium
		
      (lutris.override {
	extraPkgs = pkgs: [
	  wineWowPackages.stable
	  winetricks
	  jansson
	];	 
      })
	
      unstablePkgs.obsidian
      (unstablePkgs.matcha-gtk-theme.override {
        themeVariants = [ "sea" ];
    	colorVariants = [ "dark" ];
       })
       (unstablePkgs.qogir-icon-theme.override { 
         colorVariants = [ "standard" ];
    	 themeVariants = [ "manjaro" ];
       })
  ];
  
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
	"firefox.desktop"
        "org.gnome.Terminal.desktop"
        "thunderbird.desktop"
        "steam.desktop"
     ];
     # 'gnome-extensions list' for a list
     enabled-extensions = [
       "appindicatorsupport@rgcjonas.gmail.com"
       "aztaskbar@aztaskbar.gitlab.com"
       "gsconnect@andyholmes.github.io"
       "gmind@tungstnballon.gitlab.com"
       "syncthing@gnome.2nv2u.com"
       "no-overview@fthx"
       "tiling-assistant@leleat-on-github"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "Vitals@CoreCoding.com"
     ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      cursor-theme = "Adwaita";
    };
    "org/gnome/gedit/preferences/editor" = {
      scheme = "kate";
    };
    "org/gnome/desktop/background" = {
      "picture-uri" = "/home/fne/.config/background.jpg";
    };
    "org/gnome/desktop/screensaver" = {
      "picture-uri" = "/home/fne/.config/background.jpg";
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout="appmenu:minimize,maximize,close";
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
    };
    "org/gnome/shell/extensions/aztaskbar" = {
      panel-location = "TOP";
      indicator-color-focused = "rgb(46,179,152)";
      indicator-color-running = "rgb(164,172,170)";
    };
    "org/gnome/shell/extensions/user-theme" = {
      name = "Matcha-dark-sea";
    };
    "org/gnome/shell/extensions/tiling-assistant" = {
      window-gap = 2;
    };
    "org/gnome/shell/extensions/vitals" = {
      hot-sensors = [
        "_memory_usage_"
        "__temperature_avg__"
        "_processor_usage_"
        "__network-rx_max__"
        "__network-tx_max__"
      ];
    };
  };
  
  gtk = {
    enable = true;
    iconTheme = {
      name = "Qogir-manjaro";
    };
    theme = {
      name = "Matcha-dark-sea";
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
    # Set your theme for gtk4 applications
    GTK_THEME = "Matcha-dark-sea";
      
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
  home.username = "fne";
  home.homeDirectory = "/home/fne";
    
  /* The home.stateVersion option does not have a default and must be set equal to your Nix-Channel-Version */
  home.stateVersion = "23.11";
    
  # Let Home Manager install and manage your shell (for e.g. environment variables)
  programs.fish.enable = true;
    
  # Allow Home Manager to manage itself
  programs.home-manager.enable = true;
}
