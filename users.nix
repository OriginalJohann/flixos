# Use this file to manage which users should be created

{ config, pkgs, ... }:

{
  # Create new users
  users.users.fne = {
    isNormalUser = true;
    description = "Florian Neukirch";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "audio" "scanner" "lp" "data" ];
  };
  
  users.users.hyprflo = {
    isNormalUser = true;
    description = "Hyprflo";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "audio" "scanner" "lp" "data" ];
    password = "hyprland";
  };
  
  users.users.liri = {
    isNormalUser = true;
    description = "Linn Riedel-Neukirch";
    shell = pkgs.fish;
    extraGroups = [  "audio" "scanner" "lp" "data" ];
    password = "password";
  };
  
  # Create data group
  users.groups.data.gid = 1000;
}
