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
    networkmanagerapplet
    nemo
    brightnessctl
    clipse
    gwenview
    okular
    ark
    waybar
    swww
    kdePackages.qtwayland
    pavucontrol
    grim
    slurp
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.hyprlock.enable = true;
  services.gnome.gnome-keyring.enable = true;

  security.polkit.enable = true;
  security.pam.services.hyprlock = { };
  security.pam.services.login.enableGnomeKeyring = true;
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

      # remove bad plasma thingy
      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        plasma-browser-integration
        elisa
        konsole
        khelpcenter
      ];

    };
  };
}
