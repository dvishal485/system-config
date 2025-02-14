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
      "${config.xdg.configHome}/${configFile}".source = config.lib.file.mkOutOfStoreSymlink "${nixHomeConfigPath}/${configFile}";
    };
  };
in
{
  # fd -H -d1 --base-directory .config --strip-cwd-prefix -x echo '(mkHomeConfig "{}")'
  imports =
    let
      listOfConfigs = [
        "Thunar"
        "dunst"
        "hypr"
        "mpv"
        "rofi"
        "swaync"
        "waybar"
        "zed"
        ".gitignore"
      ];
    in
    map mkHomeConfig listOfConfigs;
}
