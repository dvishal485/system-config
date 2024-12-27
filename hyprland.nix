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
    libsecret
    libcanberra-gtk3
    arc-icon-theme
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  services.dbus.packages = [ pkgs.seahorse ];
  programs.hyprlock.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  security.polkit.enable = true;
  security.pam.services.hyprlock = { };
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.DUNST_ICON_PATH = "${pkgs.arc-icon-theme}/share/icons/Moka/32x32/web";
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
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
