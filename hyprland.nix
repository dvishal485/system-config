{
  pkgs,
  pkgs-unstable,
  inputs,
  lib,
  config,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # hypr
    inputs.hyprpolkitagent.packages."${pkgs.system}".hyprpolkitagent
    inputs.hypridle.packages."${pkgs.system}".hypridle
    inputs.hyprlock.packages."${pkgs.system}".hyprlock

    rofi
    egl-wayland
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
    hyprshot
    grim
    libsecret
    libgnome-keyring
    libcanberra-gtk3
    kdePackages.qt6ct
    libsForQt5.qt5ct
    udiskie
    wmctrl
    libinput-gestures
  ];

  programs.foot = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      main = {
        dpi-aware = true;
      };
    };
  };

  home-manager.users.seattle = {
    home.packages = with pkgs; [
      pavucontrol
      gnome-calendar
      qalculate-gtk
      nwg-look
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.default;
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
    package = inputs.hyprland.packages.${pkgs.system}.default;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  services.dbus = {
    enable = true;
    # packages = [
    #   pkgs.seahorse # already added by programs.seahorse.enable
    # ];
  };

  programs.thunar-with-flags = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
    ];
    configureFlags = [ "--disable-wallpaper-plugin" ];
  };

  # enabled by programs.thunar
  # programs.xfconf.enable = lib.mkIf (config.programs.thunar.enable) true;

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

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [ "foot" ];
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
