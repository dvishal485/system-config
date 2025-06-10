{
  pinned-pkgs,
  pkgs,
  lib,
  config,
  ...
}:
let
  patched-fprintd = pinned-pkgs.fprintd.override {
    libfprint = pkgs.libfprint-focaltech-2808-a658;
  };
in
{
  services.fprintd = {
    enable = true;
    package = patched-fprintd;
  };

  security.pam.services = lib.mkIf (config.services.fprintd.enable) {
    greetd.fprintAuth = false;
    sudo.fprintAuth = false;
    hyprlock.fprintAuth = false;
  };
}
