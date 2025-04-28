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

  programs.foot = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      main = {
        dpi-aware = true;
      };

      bell = {
        urgent = "yes";
      };

      # dracula theme
      colors = {
        # alpha=1.0
        background = "282a36";
        foreground = "f8f8f2";

        ## Normal/regular colors (color palette 0-7)
        regular0 = "21222c"; # black
        regular1 = "ff5555"; # red
        regular2 = "50fa7b"; # green
        regular3 = "f1fa8c"; # yellow
        regular4 = "bd93f9"; # blue
        regular5 = "ff79c6"; # magenta
        regular6 = "8be9fd"; # cyan
        regular7 = "f8f8f2"; # white

        ## Bright colors (color palette 8-15)
        bright0 = "6272a4"; # bright black
        bright1 = "ff6e6e"; # bright red
        bright2 = "69ff94"; # bright green
        bright3 = "ffffa5"; # bright yellow
        bright4 = "d6acff"; # bright blue
        bright5 = "ff92df"; # bright magenta
        bright6 = "a4ffff"; # bright cyan
        bright7 = "ffffff"; # bright white

        selection-foreground = "ffffff";
        selection-background = "44475a";

        urls = "8be9fd";
      };
    };
  };

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

  programs.dconf.enable = true;
  services.gnome.evolution-data-server.enable = true;
  services.gnome.gnome-online-accounts.enable = true;

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
