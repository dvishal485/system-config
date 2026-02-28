{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
{
  specialisation = {
    gaming.configuration =
      let
        kernel = pkgs.linuxPackages_xanmod_latest;
      in
      {
        system.nixos.tags = [ "gaming" ];
        environment.etc."specialisation".text = "gaming";

        # xanmod kernel for better gaming performance
        boot.kernelPackages = lib.mkForce kernel;
        hardware.nvidia = {
          package = kernel.nvidiaPackages.production;
          # Dynamic boost is already enabled in base config
          # No need to force it here as it inherits from base
        };

        imports = [
          ../modules/gaming.nix
        ];

        programs.gaming = {
          enable = true;
          lutris.enable = true;
          lutris.package = pkgs.lutris;
          gamingModeToggleScript = builtins.readFile ../../../home/users/seattle/.config/hypr/scripts/perf_mode.sh;
          heroic.enable = false;
          libPackages = with pkgs; [
            vkbasalt
          ];
          wine = {
            enable = true;
            # nix flake show github:fufexan/nix-gaming
            # package = inputs.nix-gaming.packages.${pkgs.system}.wine-ge;
            package = pkgs.wineWowPackages.waylandFull;
          };
          gamemode.enable = true;
          gamescope.enable = false; # doesn't work, also not required
          mangohud.enable = true;
        };
      };
  };
}
