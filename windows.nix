{ inputs, pkgs, ... }:
{
  hardware.graphics.enable32Bit = true;
  environment.systemPackages =
    with pkgs;
    [
    ]
    # nix flake show github:fufexan/nix-gaming
    ++ (with inputs.nix-gaming.packages.${pkgs.system}; [
      (lutris.override {
        extraPkgs = pkgs: [ ];
      })
      wine-ge
      mangohud
      gamemode
    ]);
  programs.gamemode.enable = true;

  nix.settings = {
    substituters = [ "https://nix-gaming.cachix.org" ];
    trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
  };

}
