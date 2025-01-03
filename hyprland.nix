{
  pkgs,

  ...
}:
{
  environment.systemPackages = with pkgs; [
    kitty
    rofi
    egl-wayland
    dunst
    networkmanagerapplet
    nautilus
    brightnessctl
    clipse
    gwenview
    okular
    ark
    waybar
    swww
    kdePackages.qtwayland
    pavucontrol
    hyprshot
    gnome-keyring
    dconf-editor
    libsecret
    libgnome-keyring
    libcanberra-gtk3
    kdePackages.qt6ct
    libsForQt5.qt5ct
    nwg-look
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  services.dbus = {
    enable = true;
    packages = [ pkgs.seahorse ];
  };
  programs.hyprlock.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
  services.gvfs.enable = true;

  security.polkit.enable = true;
  security.pam.services.hyprlock = { };
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.gnomekey.enableGnomeKeyring = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
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
