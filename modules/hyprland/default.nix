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
        default =
          if cfg.useFlake then
            hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default
          else
            pkgs.hyprland;
      };
      portalPackage = lib.mkOption {
        type = lib.types.package;
        description = "Hyprland portal package";
        default =
          if cfg.useFlake then
            hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
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

    services.logind.settings.Login = lib.mkIf cfg.logindMask {
      HandleLidSwitch = "ignore";
      HandlePowerKey = "ignore";
    };

    environment.sessionVariables = lib.mkIf cfg.setEnvironment {
      # Wayland/Electron support
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";

      # GTK settings
      GDK_BACKEND = "wayland,x11"; # Prefer wayland but fallback to X11
      GDK_SCALE = "1";

      # Qt settings
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_QPA_PLATFORM = "wayland;xcb"; # Prefer wayland but fallback to XCB
      QT_QPA_PLATFORMTHEME = "qt6ct";

      # Hyprland runs on AMD iGPU by default (better battery)
      # Applications can use nvidia-offload for dGPU rendering
      # This is the recommended setup for hybrid graphics laptops
      WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0"; # Prefer AMD for compositor
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
              hyprland-qtutils
              hyprlock
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
            ]
          else
            [ ]
        )
        ++ (
          if cfg.enableDesktopManagerTools then
            [
              rofi
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
