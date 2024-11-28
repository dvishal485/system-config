{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  ...
}:
{
  # specialisation = {
  #   disable-fprintd.configuration = {
  #     system.nixos.tags = [ "disable-fprintd" ];
  #     services.fprintd.enable = lib.mkForce false;
  #   };
  # };

  services.fprintd = {
    enable = true;
    package = pkgs.fprintd.override { libfprint = pkgs-unstable.libfprint-focaltech-2808-a658; };
  };

  security.pam.services.login.fprintAuth = lib.mkIf (config.services.fprintd.enable) false;
}
