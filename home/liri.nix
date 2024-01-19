# User configuration with homemanager

{ config, pkgs, inputs, unstablePkgs, gtkThemeFromScheme, ... }:

{
  # Manage user configuration
    home.packages = with pkgs; [
    	gnomeExtensions.arcmenu
        #gnomeExtensions.gtk4-desktop-icons-ng-ding
    	google-chrome
    	papirus-icon-theme
    ];
  
    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
	favorite-apps = [
	  "org.gnome.Nautilus.desktop"
	  "google-chrome.desktop"
          "thunderbird.desktop"
        ];
      	# 'gnome-extensions list' for a list
      	enabled-extensions = [
      	  "appindicatorsupport@rgcjonas.gmail.com"
      	  "arcmenu@arcmenu.com"
      	  "aztaskbar@aztaskbar.gitlab.com"
      	  "gsconnect@andyholmes.github.io"
      	  "no-overview@fthx"
      	  "tiling-assistant@leleat-on-github"
          "user-theme@gnome-shell-extensions.gcampax.github.com"
      	];
      };
      "org/gnome/shell/extensions/aztaskbar" = {
	    panel-location = "BOTTOM";
      };
      "org/gnome/desktop/background" = {
        picture-uri = "/home/liri/.config/background.jpg";
      };
      "org/gnome/desktop/screensaver" = {
        picture-uri = "/home/liri/.config/background.jpg";
      };
      "org/gnome/shell/extensions/tiling-assistant" = {
        window-gap = 2;
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout="appmenu:minimize,maximize,close";
      };
      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
      };
      "org/gnome/shell/extensions/arcmenu" = {
        menu-layout = "Windows";
      };
    };
  
    gtk = {
      enable = true;
      iconTheme = {
        name = "Papirus";
      };
    };
    
    # Create XDG Dirs
    xdg = {
      userDirs = {
        enable = true;
        createDirectories = true;
      };
    };
    
    # Set background image
    home.file.".config/background.jpg".source = .../config/files/media/wallpapers/background02.jpg;
  
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
    
    /* The home.stateVersion option does not have a default and must be set equal to your Nix-Channel-Version */
    home.stateVersion = "23.11";
    
    # Let Home Manager install and manage your shell (for e.g. environment variables)
    programs.fish.enable = true;
    
    # Allow Home Manager to manage itself
    programs.home-manager.enable = true;
}
