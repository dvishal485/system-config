# Genrates a symlink for each file in the .config directory
# Author: @dvishal485
#
# This file is auto-generated using the following command:
# devbox run config
{ config, ... }:
let
  nixHomeConfigPath = "/etc/nixos/.config";
  mkHomeConfig = configFile: {
    home.file = {
      ".config/${configFile}".source = config.lib.file.mkOutOfStoreSymlink "${nixHomeConfigPath}/${configFile}";
    };
  };
in
{
  # fd -H -d1 --base-directory .config --strip-cwd-prefix -x echo '(mkHomeConfig "{}")'
  imports = [
    (mkHomeConfig "Thunar")
    (mkHomeConfig "dunst")
    (mkHomeConfig "hypr")
    (mkHomeConfig "mpv")
    (mkHomeConfig "rofi")
    (mkHomeConfig "swaync")
    (mkHomeConfig "waybar")
    (mkHomeConfig "zed")
    (mkHomeConfig ".gitignore")
  ];
}
