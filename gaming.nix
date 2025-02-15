{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.programs.gaming;
in
{
  options = {
    programs.gaming = {
      enable = lib.mkEnableOption "Enable gaming module with lutris";
      lutris = {
        package = lib.mkOption {
          type = lib.types.package;
          description = "Lutris package";
          default = pkgs.lutris;
        };
        envPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          description = "Extra packages to install with lutris and system";
          default = [ ];
        };
        libPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          description = "Extra libraries to install with lutris";
          default = [ ];
        };
      };
      wine = {
        enable = lib.mkEnableOption "Enable wine";
        package = lib.mkOption {
          type = lib.types.package;
          description = "Wine package";
          default = pkgs.wineWowPackages.stable;
        };
      };
      gamemode = {
        enable = lib.mkEnableOption "Enable gamemode";
        enableRenice = lib.mkOption {
          type = lib.types.bool;
          description = "Renice gamemode";
          default = true;
        };
      };
      gamescope = {
        enable = lib.mkEnableOption "Enable gamescope";
        package = lib.mkOption {
          default = pkgs.gamescope;
          type = lib.types.package;
          description = "Package to use";
        };
        enableRenice = lib.mkOption {
          type = lib.types.bool;
          description = "Renice gamescope";
          default = true;
        };
      };
      mangohud = {
        enable = lib.mkEnableOption "Enable mangohud";
        enableMangojuice = lib.mkOption {
          type = lib.types.bool;
          description = "Enable mangojuice";
          default = cfg.mangohud.enable;
        };
        package = lib.mkOption {
          default = pkgs.mangohud;
          type = lib.types.package;
          description = "Package to use";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics.enable32Bit = true;

    programs.gamemode = lib.mkIf cfg.gamemode.enable {
      enable = true;
      enableRenice = cfg.gamemode.enableRenice;
    };

    programs.gamescope = lib.mkIf cfg.gamescope.enable {
      enable = true;
      package = cfg.gamescope.package;
      capSysNice = cfg.gamescope.enableRenice;
    };

    environment.systemPackages =
      let
        winePkg = lib.optional cfg.wine.enable cfg.wine.package;
        gamescopePkg = lib.optional cfg.gamescope.enable cfg.gamescope.package;
        lutrisExtras = cfg.lutris.envPackages ++ cfg.lutris.libPackages;
        lutrisPkg = cfg.lutris.package.override {
          extraPkgs = pkgs: winePkg ++ gamescopePkg ++ lutrisExtras;
        };
      in
      [
        lutrisPkg
      ]
      ++ lib.optional cfg.mangohud.enable cfg.mangohud.package
      ++ lib.optional cfg.mangohud.enableMangojuice pkgs.mangojuice
      ++ cfg.lutris.envPackages
      ++ winePkg;
  };

  meta.maintainers = [ lib.maintainers.imsick ];
}
