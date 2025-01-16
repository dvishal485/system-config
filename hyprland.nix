{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    rofi
    egl-wayland
    swaynotificationcenter
    networkmanagerapplet
    nautilus
    brightnessctl
    clipse
    viewnior
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
    gnome-calendar
    gnome-calculator
    wlsunset
    udiskie
    hyprpolkitagent
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  services.dbus = {
    enable = true;
    packages = [ pkgs.seahorse ];
  };

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "alacritty";
  };

  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  programs.dconf.enable = true;
  services.gnome.evolution-data-server.enable = true;
  services.gnome.gnome-online-accounts.enable = true;

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
  services.gvfs.enable = true;

  services.smartd = {
    enable = true;
    autodetect = true;
  };

  security.polkit.enable = true;
  security.pam.services.hyprlock = { };
  security.pam.services.login.enableGnomeKeyring = true;
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
}
