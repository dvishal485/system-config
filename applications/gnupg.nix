{ pkgs, ... }:
{
  programs.gnupg = {
    dirmngr.enable = true;
    agent = {
      enable = true;
      enableBrowserSocket = true;
      enableSSHSupport = false;
      pinentryPackage = pkgs.pinentry-gnome3;
    };
  };
}
