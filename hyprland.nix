{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    kitty
    rofi
    dunst
    seahorse
  ];

  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;
  programs.waybar = {
    enable = true;
  };
  services.gnome.gnome-keyring.enable = true;

  security.polkit.enable = true;
  security.pam.services.hyprlock = { };
  security.pam.services.sddm.enableGnomeKeyring = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  specialisation = {
    plasma-6.configuration = {
      system.nixos.tags = [ "plasma-6" ];
      services.desktopManager.plasma6.enable = true;
    };
  };
}
