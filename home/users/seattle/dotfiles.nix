_: {
  imports = [
    ../../config-dotfiles.nix
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
      sourcePath = "./devbox/devbox-global.json";
      target = "devbox/global/default/devbox.json";
    };
    "devbox.lock" = {
      enable = true;
      sourcePath = "./devbox/devbox-global.lock";
      target = "devbox/global/default/devbox.lock";
    };
  };
}
