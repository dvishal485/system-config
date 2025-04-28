{ config, ... }:
{
  imports = [
    ../../applications/config-dotfiles.nix
  ];

  programs.config-dotfiles.sources = {
    "Thunar".enable = true;
    "dunst".enable = false;
    "hypr".enable = true;
    "mpv".enable = true;
    "rofi".enable = true;
    "swaync".enable = true;
    "udiskie".enable = true;
    "waybar".enable = true;
    "zed".enable = true;
    ".gitignore".enable = false;
    "devbox.json" = {
      enable = true;
      sourcePath = "devbox/devbox-global.json";
      configPath = "${config.xdg.dataHome}/devbox/global/default";
    };
    "devbox.lock" = {
      enable = true;
      sourcePath = "devbox/devbox-global.lock";
      configPath = "${config.xdg.dataHome}/devbox/global/default";
    };
  };
}
