{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
{
  specialisation = {
    plasma-6.configuration = {
      system.nixos.tags = [ "plasma-6" ];
      services.desktopManager.plasma6.enable = true;
    };
  };
}
