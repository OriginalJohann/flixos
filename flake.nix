{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };
    nix-colors.url = "github:misterio77/nix-colors";
  };
  
  outputs = inputs@{ nixpkgs, home-manager, unstable, ... }:
  let 
    system = "x86_64-linux";
    
    pkgs = import nixpkgs {
      inherit system;
      config = {
	  allowUnfree = true;
      };
    };
    
    unstablePkgs = import unstable {
      inherit system;
      config = {
	allowUnfree = true;
	permittedInsecurePackages = [
          "electron-25.9.0" # For Obsidian
        ];
      };
    }; 
  in
  {
    nixosConfigurations = {
      flixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; inherit inputs; inherit unstablePkgs;};
        modules = [ 
          ./configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager = {
              extraSpecialArgs = {
                inherit (inputs.nix-colors.lib-contrib {inherit pkgs;}) gtkThemeFromScheme;
                inherit inputs;
                inherit unstablePkgs;
              };
              useGlobalPkgs = true;
              useUserPackages = true;
              users = {
                fne = import ./home/fne.nix;
                hyprflo = import ./home/hyprflo.nix;
                liri = import ./home/liri.nix;
              };
            };
          }
        ];
      };
    };
  };
}
