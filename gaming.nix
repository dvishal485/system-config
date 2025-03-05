{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.programs.gaming;
  patchDesktop =
    pkg: appName: from: to:
    lib.hiPrio (
      pkgs.runCommand "nv-offload-${appName}" { } ''
        ${pkgs.coreutils}/bin/mkdir -p $out/share/applications
        ${pkgs.gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
      ''
    );
  GPUOffloadApp = pkg: desktopName: patchDesktop pkg desktopName "^Exec=" "Exec=nvidia-offload ";
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
        nvOffload = lib.mkOption {
          type = lib.types.bool;
          description = "Enable nvidia offload for lutris";
          default = config.hardware.nvidia.prime.offload.enable;
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
      ++ lib.optional cfg.lutris.nvOffload (GPUOffloadApp lutrisPkg "net.lutris.Lutris")
      ++ lib.optional cfg.mangohud.enable cfg.mangohud.package
      ++ lib.optional cfg.mangohud.enableMangojuice pkgs.mangojuice
      ++ cfg.lutris.envPackages
      ++ winePkg;

    assertions =
      let
        offload = config.hardware.nvidia.prime.offload;
      in
      [
        {
          assertion = !cfg.lutris.nvOffload || (offload.enable && offload.enableOffloadCmd);
          message = "nvOffload requires NVIDIA PRIME Offload Mode enabled with offload-command";
        }
      ];
  };

  meta.maintainers = [ lib.maintainers.imsick ];
}
