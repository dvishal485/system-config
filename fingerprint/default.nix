{
  pkgs,
  lib,
  config,
  ...
}:
{
  nixpkgs.overlays = [ (self: super: { libfprint-focaltech = super.callPackage ./driver.nix { }; }) ];
  services.fprintd = {
    enable = true;
    package = pkgs.fprintd.override { libfprint = pkgs.libfprint-focaltech; };
  };
  security.pam.services.login.fprintAuth = false;
}
