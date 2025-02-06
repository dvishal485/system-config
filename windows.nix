{ inputs, pkgs, ... }:
{
  hardware.graphics.enable32Bit = true;

  programs.gamemode.enable = true;
  environment.systemPackages =
    with pkgs;
    [
      (lutris.override {
        extraPkgs = pkgs: [ ];
      })
      mangohud
    ]
    # nix flake show github:fufexan/nix-gaming
    ++ ([
      inputs.nix-gaming.packages.${pkgs.system}.wine-ge
    ]);

  nix.settings = {
    substituters = [ "https://nix-gaming.cachix.org" ];
    trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
  };
}
