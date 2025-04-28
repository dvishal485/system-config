{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    corefonts
    stix-two
    # https://github.com/NixOS/nixpkgs/blob/nixos-24.11/pkgs/data/fonts/nerdfonts/shas.nix
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    # nerd-fonts.jetbrains-mono
  ];
}
