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
      pkgs.runCommand "wrapped-${appName}" { } ''
        ${pkgs.coreutils}/bin/mkdir -p $out/share/applications
        ${pkgs.gnused}/bin/sed -E 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
      ''
    );
  gamemodeToggleScript = cfg.lutris.gamingModeToggleScript;
  wrapperApp =
    pkg: desktopName:
    let
      preCmd = if cfg.lutris.nvOffload then "nvidia-offload" else "";
      replace_pattern =
        if gamemodeToggleScript == null then
          ''Exec=${preCmd} \1''
        else
          let
            gamingModeToggle = pkgs.writeShellScript "toggle-gaming-mode" gamemodeToggleScript;
          in
          ''Exec=${gamingModeToggle} \&\& ${preCmd} \1 \&\& ${gamingModeToggle}'';
    in
    patchDesktop pkg desktopName "^Exec=(.*)" replace_pattern;
in
{
  options = {
    programs.gaming = {
      enable = lib.mkEnableOption "Enable gaming module with lutris";
      lutris = {
        enable = lib.mkEnableOption "Enable lutris";
        gamingModeToggleScript = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Script used to toggle gaming mode; runs before and after lutris";
          default = null;
        };
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
      };
      heroic = {
        enable = lib.mkEnableOption "Enable heroic";
        package = lib.mkOption {
          type = lib.types.package;
          description = "Heroic package";
          default = pkgs.heroic;
        };
        nvOffload = lib.mkOption {
          type = lib.types.bool;
          description = "Enable nvidia offload for heroic";
          default = config.hardware.nvidia.prime.offload.enable;
        };
      };
      envPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        description = "Extra packages to install with lutris and/or heroic";
        default = [ ];
      };
      libPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        description = "Extra libraries to install with lutris and/or heroic";
        default = [ ];
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
        extraPkgs = cfg.envPackages ++ cfg.libPackages;
        lutrisPkg = cfg.lutris.package.override {
          extraPkgs = pkgs: winePkg ++ gamescopePkg ++ extraPkgs;
        };
        heroicPkg = cfg.heroic.package.override {
          extraPkgs = pkgs: winePkg ++ gamescopePkg ++ extraPkgs;
        };
      in
      lib.optional cfg.heroic.enable heroicPkg
      ++ lib.optional cfg.lutris.enable lutrisPkg
      ++ lib.optional (cfg.lutris.enable && (cfg.lutris.nvOffload || gamemodeToggleScript != null)) (
        wrapperApp lutrisPkg "net.lutris.Lutris"
      )
      ++ lib.optional cfg.mangohud.enable cfg.mangohud.package
      ++ lib.optional cfg.mangohud.enableMangojuice pkgs.mangojuice
      ++ cfg.envPackages
      ++ winePkg;

    assertions =
      let
        offload = config.hardware.nvidia.prime.offload;
      in
      [
        {
          assertion =
            (cfg.lutris.nvOffload || cfg.heroic.nvOffload) -> (offload.enable && offload.enableOffloadCmd);
          message = "nvOffload requires NVIDIA PRIME Offload Mode enabled with offload-command";
        }
      ];
  };

  meta.maintainers = [ lib.maintainers.imsick ];
}
