{ pkgs, ... }:
{
  imports = [
    ../modules/thunar.nix
  ];

  programs.thunar-with-flags = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
    ];
    configureFlags = [ "--disable-wallpaper-plugin" ];
  };

  environment.systemPackages = with pkgs; [
    mate.engrampa # alternative to ark
    unrar
    unzip
  ];
}
