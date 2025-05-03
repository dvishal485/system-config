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

        # xanmod kernel
        boot.kernelPackages = lib.mkForce kernel;
        hardware.nvidia.package = kernel.nvidiaPackages.mkDriver {
          version = "570.133.07";
          sha256_64bit = "sha256-LUPmTFgb5e9VTemIixqpADfvbUX1QoTT2dztwI3E3CY=";
          sha256_aarch64 = "sha256-yTovUno/1TkakemRlNpNB91U+V04ACTMwPEhDok7jI0=";
          openSha256 = "sha256-9l8N83Spj0MccA8+8R1uqiXBS0Ag4JrLPjrU3TaXHnM=";
          settingsSha256 = "sha256-XMk+FvTlGpMquM8aE8kgYK2PIEszUZD2+Zmj2OpYrzU=";
          persistencedSha256 = "sha256-G1V7JtHQbfnSRfVjz/LE2fYTlh9okpCbE4dfX9oYSg8=";
        };

        imports = [
          ../modules/gaming.nix
        ];

        programs.gaming = {
          enable = true;
          lutris.enable = true;
          lutris.package = pkgs-unstable.lutris;
          gamingModeToggleScript = builtins.readFile ../../../home/users/seattle/.config/hypr/scripts/perf_mode.sh;
          heroic.enable = false;
          libPackages = with pkgs; [
            vkbasalt
          ];
          wine = {
            enable = true;
            # nix flake show github:fufexan/nix-gaming
            # package = inputs.nix-gaming.packages.${pkgs.system}.wine-ge;
            package = pkgs-unstable.wineWowPackages.waylandFull;
          };
          gamemode.enable = true;
          gamescope.enable = false; # doesn't work, also not required
          mangohud.enable = true;
        };
      };
  };
}
