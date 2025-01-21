{
  pkgs,
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
    enable = true;
    package = patched-fprintd;
  };

  security.pam.services = lib.mkIf (config.services.fprintd.enable) {
    greetd.fprintAuth = false;
    sudo.fprintAuth = false;
    hyprlock.fprintAuth = false;
    # hyprlock.text = lib.mkIf (config.services.fprintd.enable) ''
    #   account required ${pkgs.pam}/lib/security/pam_unix.so
    #   # check passwork before fprintd
    #   auth sufficient ${pkgs.pam}/lib/security/pam_unix.so try_first_pass likeauth
    #   auth [success=1 default=ignore] ${focaltech-patched-fprintd}/lib/security/pam_fprintd.so max_tries=3 timeout=10
    #   auth include login
    # '';
  };
}
