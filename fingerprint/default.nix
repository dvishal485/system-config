{ pkgs, lib, config, ... }:
{
  nixpkgs.overlays = [ (self: super: { libfprint-focaltech = super.callPackage ./driver.nix { }; }) ];
  services.fprintd = {
    enable = true;
    package = pkgs.fprintd.override { libfprint = pkgs.libfprint-focaltech; };
  };
  security.pam.services.sddm = lib.mkIf (config.services.fprintd.enable) {
    text = ''
      auth     [success=1 new_authtok_reqd=1 default=ignore]     pam_unix.so try_first_pass likeauth
      nullok
      auth     sufficient pam_fprintd.so
    '';
  };
}
