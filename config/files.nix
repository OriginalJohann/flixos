{ pkgs, config, ... }:

{
  # Place Files Inside Home Directory
  home.file.".config/zaney-stinger.mov".source = ./files/media/zaney-stinger.mov;
  home.file.".emoji".source = ./files/emoji;
  home.file.".face".source = ./files/face.jpg;
  home.file."Pictures/Wallpapers" = {
    source = ./files/media/wallpapers;
    recursive = true;
  };
  home.file.".local/share/fonts" = {
    source = ./files/fonts;
    recursive = true;
  };
}
