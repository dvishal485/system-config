{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    rofi
    egl-wayland
    swaynotificationcenter
    networkmanagerapplet
    # nautilus
    brightnessctl
    clipse
    # ark
    hypridle
    pkgs-unstable.hyprlock
    mate.engrampa
    unrar
    unzip
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

  home-manager.users.seattle = {
    home.packages = with pkgs; [
      pavucontrol
      gnome-calendar
      qalculate-gtk
      nwg-look
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = false;
    };

    services.wlsunset = {
      enable = true;
      latitude = 28.74;
      longitude = 77.11;
      temperature.day = 6000;
      temperature.night = 5600;
    };
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  services.dbus = {
    enable = true;
    packages = [ pkgs.seahorse ];
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
    ];
  };
  programs.xfconf.enable = lib.mkIf (config.programs.thunar.enable) true;

  # programs.nautilus-open-any-terminal = {
  #   enable = true;
  #   terminal = "alacritty";
  # };

  programs.dconf.enable = true;
  services.gnome.evolution-data-server.enable = true;
  services.gnome.gnome-online-accounts.enable = true;

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
  services.gvfs.enable = true; # trash service
  services.tumbler.enable = true; # img thumbnail service

  services.smartd = {
    enable = true;
    autodetect = true;
  };

  services.logind = {
    lidSwitch = "ignore";
    powerKey = "ignore";
  };

  security.polkit.enable = true;

  security.pam.services.sudo.nodelay = true;
  security.pam.services.hyprlock = {
    nodelay = true;
  };
  security.pam.services.greetd.enableGnomeKeyring = true;

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
