# Genrates a symlink for each file in the .config directory
# Author: @dvishal485
#
# This file is auto-generated using the following command:
# devbox run config
{ config, ... }:
let
  nixConfig = "/etc/nixos";
  nixHomeConfigPath = "${nixConfig}/.config";
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
        "udiskie"
        "waybar"
        "zed"
        ".gitignore"
      ];
    in
    map mkHomeConfig listOfConfigs;

  # devbox global config and lock file
  home.file."${config.xdg.dataHome}/devbox/global/default/devbox.json".source = config.lib.file.mkOutOfStoreSymlink "${nixConfig}/devbox/devbox-global.json";
  home.file."${config.xdg.dataHome}/devbox/global/default/devbox.lock".source = config.lib.file.mkOutOfStoreSymlink "${nixConfig}/devbox/devbox-global.lock";
}
