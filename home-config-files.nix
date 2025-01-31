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
      ".config/test/${configFile}".source = config.lib.file.mkOutOfStoreSymlink "${nixHomeConfigPath}/${configFile}";
    };
  };
in
{
  # fd -d1 --base-directory .config --strip-cwd-prefix -x echo '(mkHomeConfig "{}")'
  imports = [
    (mkHomeConfig "Thunar")
    (mkHomeConfig "dunst")
    (mkHomeConfig "hypr")
    (mkHomeConfig "rofi")
    (mkHomeConfig "swaync")
    (mkHomeConfig "waybar")
    (mkHomeConfig "zed")
  ];
}
