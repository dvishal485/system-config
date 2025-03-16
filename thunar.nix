{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.thunar-with-flags;
  thunarWithFlags = cfg.package.overrideAttrs (o: {
    configureFlags = o.configureFlags ++ cfg.configureFlags;
  });
  finalPackage =
    if cfg.plugins == [ ] then
      thunarWithFlags
    else
      pkgs.callPackage "${builtins.dirOf pkgs.xfce.thunar.meta.position}/wrapper.nix" {
        thunarPlugins = cfg.plugins;
        thunar = thunarWithFlags;
      };
in
{
  meta = {
    maintainers = lib.teams.xfce.members ++ [ lib.maintainers.imsick ];
  };

  options = {
    programs.thunar-with-flags = {
      enable = lib.mkEnableOption "Thunar, the Xfce file manager";

      plugins = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.package;
        description = "List of thunar plugins to install.";
        example = lib.literalExpression "with pkgs.xfce; [ thunar-archive-plugin thunar-volman ]";
      };

      configureFlags = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.str;
        description = "List of flags to pass to the Thunar build.";
        example = lib.literalExpression ''
          [ "--disable-wallpaper-plugin" ]
        '';
      };

      package = lib.mkOption {
        default = pkgs.xfce.thunar;
        type = lib.types.package;
        description = "The Thunar package to use.";
      };
      finalPackage = lib.mkOption {
        type = lib.types.package;
        readOnly = true;
        description = "The final Thunar package with custom flags and plugins";
        default = finalPackage;
      };
    };
  };

  config = lib.mkIf cfg.enable ({
    environment.systemPackages = [
      finalPackage
    ];

    services.dbus.packages = [
      finalPackage
    ];

    systemd.packages = [
      finalPackage
    ];

    programs.xfconf.enable = true;
  });
}
