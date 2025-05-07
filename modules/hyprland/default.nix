{
  hyprland,
  pkgs,
  pkgs-unstable,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.hyprland-full;
in
{
  options = {
    programs.hyprland-full = {
      enable = lib.mkEnableOption "Enable hyprland module";
      useFlake = lib.mkOption {
        type = lib.types.bool;
        description = "Whether to use hyprland flake package or nixpkgs package";
        default = false;
      };
      package = lib.mkOption {
        type = lib.types.package;
        description = "Hyprland package";
        default = if cfg.useFlake then hyprland.packages.${pkgs.system}.default else pkgs.hyprland;
      };
      portalPackage = lib.mkOption {
        type = lib.types.package;
        description = "Hyprland portal package";
        default =
          if cfg.useFlake then
            hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
          else
            pkgs.xdg-desktop-portal-hyprland;
      };
      enableHyprTools = lib.mkOption {
        type = lib.types.bool;
        description = "Hypr utils and tools";
        default = true;
      };
      enableDesktopManagerTools = lib.mkOption {
        type = lib.types.bool;
        description = "Hypr desktop manager tools";
        default = true;
      };
      enableQtGtk = lib.mkOption {
        type = lib.types.bool;
        description = "Qt and GTK tools/lib";
        default = true;
      };
      logindMask = lib.mkOption {
        type = lib.types.bool;
        description = "Masks toggles for lid switch and power button to be handled by Hyprland";
        default = true;
      };
      users = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Hyprland users";
        default = [ ];
      };
      setEnvironment = lib.mkOption {
        type = lib.types.bool;
        description = "Set environment variables for Hyprland";
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      package = cfg.package;
      portalPackage = cfg.portalPackage;
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [
        # hyprland portal is added by hyprland with programs.hyprland.portalPackage
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    services.logind = lib.mkIf cfg.logindMask {
      lidSwitch = "ignore";
      powerKey = "ignore";
    };

    environment.sessionVariables = lib.mkIf cfg.setEnvironment {
      NIXOS_OZONE_WL = "1";
      GDK_BACKEND = "wayland";
      GDK_SCALE = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORMTHEME = "qt6ct";
    };

    home-manager.users = lib.genAttrs cfg.users (user: {
      wayland.windowManager.hyprland = {
        enable = true;
        package = cfg.package;
        xwayland.enable = true;
        systemd.enable = false;
      };

      home.packages =
        with pkgs;
        (
          if cfg.enableHyprTools then
            [
              pkgs-unstable.hyprland-qtutils
              pkgs-unstable.hyprlock
              hyprpolkitagent
              hypridle
            ]
          else
            [ ]
        )
        ++ (
          if cfg.enableQtGtk then
            [
              kdePackages.qtwayland
              libcanberra-gtk3
              kdePackages.qt6ct
              libsForQt5.qt5ct
            ]
          else
            [ ]
        )
        ++ (
          if cfg.enableDesktopManagerTools then
            [
              rofi-wayland
              swaynotificationcenter
              networkmanagerapplet
              udiskie
              brightnessctl
              clipse
              waybar
              swww
            ]
          else
            [ ]
        );
    });
  };
}
