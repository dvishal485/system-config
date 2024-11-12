{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  ...
}:
{
  services.fprintd = {
    enable = true;
    package = pkgs.fprintd.override { libfprint = pkgs-unstable.libfprint-focaltech-2808-a658; };
  };

  security.pam.services.login.fprintAuth = lib.mkIf (config.services.fprintd.enable) false;
}
