{ ... }:
{
  home.username = "seattle";
  home.homeDirectory = "/home/seattle";
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  imports = [
    ./rest.nix
  ];
}
