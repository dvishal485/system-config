{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  ...
}:
let
  patched-fprintd = pkgs.fprintd.override {
    libfprint = pkgs.libfprint-focaltech-2808-a658;
  };
in
{
  # specialisation = {
  #   disable-fprintd.configuration = {
  #     system.nixos.tags = [ "disable-fprintd" ];
  #     services.fprintd.enable = lib.mkForce false;
  #   };
  # };

  services.fprintd = {
    enable = false;
    package = patched-fprintd;
  };

  security.pam.services.login.fprintAuth = lib.mkIf (config.services.fprintd.enable) false;
}
