{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    corefonts
    stix-two
    # https://github.com/NixOS/nixpkgs/tree/nixos-25.05/pkgs/data/fonts/nerd-fonts
    nerd-fonts.jetbrains-mono
  ];
}
