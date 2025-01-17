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
    ark
    waybar
    swww
    kdePackages.qtwayland
    hyprshot
    grim
    gnome-keyring
    libsecret
    libgnome-keyring
    libcanberra-gtk3
    kdePackages.qt6ct
    libsForQt5.qt5ct
    udiskie
    hyprpolkitagent
    wmctrl
    libinput-gestures
  ];

  home-manager.users.seattle.home.packages = with pkgs; [
    pavucontrol
    gnome-calendar
    gnome-calculator
    nwg-look
    wlsunset
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
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

  services.logind = {
    lidSwitch = "ignore";
    powerKey = "ignore";
  };

  security.polkit.enable = true;
  security.pam.services.hyprlock = { };
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.gnomekey.enableGnomeKeyring = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.HYPRSHOT_DIR = "$HOME/Pictures/Screenshots";

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };
}
