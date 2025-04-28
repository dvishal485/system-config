{
  inputs,
  config,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  use_hyprland_flake = false;

  hyprland = inputs.hyprland.packages.${pkgs.system};
  hyprland_pkg = if use_hyprland_flake then hyprland.default else pkgs.hyprland;
  xdg_portal_pkg =
    if use_hyprland_flake then
      hyprland.xdg-desktop-portal-hyprland
    else
      pkgs.xdg-desktop-portal-hyprland;
in
{
  environment.systemPackages = with pkgs; [
    # hypr
    pkgs-unstable.hyprland-qtutils
    pkgs-unstable.hyprlock
    hyprpolkitagent
    hypridle

    rofi-wayland
    swaynotificationcenter
    networkmanagerapplet
    brightnessctl
    clipse
    mate.engrampa # alternative to ark
    unrar
    unzip
    waybar
    swww
    kdePackages.qtwayland
    libcanberra-gtk3
    kdePackages.qt6ct
    libsForQt5.qt5ct
    udiskie
    # wmctrl
    # libinput-gestures
  ];

  home-manager.users.seattle = {

    wayland.windowManager.hyprland = {
      enable = true;
      package = config.programs.hyprland.package;
      xwayland.enable = true;
      systemd.enable = false;
    };

    services.wlsunset = {
      enable = true;
      latitude = 28.74;
      longitude = 77.11;
      temperature.day = 5600;
      temperature.night = 5000;
    };
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = hyprland_pkg;
    portalPackage = xdg_portal_pkg;
  };

  # enabled by programs.thunar
  # programs.xfconf.enable = lib.mkIf (config.programs.thunar.enable) true;

  # programs.nautilus-open-any-terminal = {
  #   enable = true;
  #   terminal = "alacritty";
  # };

  services.smartd = {
    enable = true;
    autodetect = true;
  };

  services.logind = {
    lidSwitch = "ignore";
    powerKey = "ignore";
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GDK_BACKEND = "wayland";
    GDK_SCALE = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_SCALE_FACTOR = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [ "foot.desktop" ];
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      # this is added by hyprland with programs.hyprland.portalPackage
      # inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
    ];
  };
}
