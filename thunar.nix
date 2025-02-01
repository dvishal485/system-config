{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.programs.thunar-with-flags;
in
{
  meta = {
    maintainers = lib.teams.xfce.members;
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
    };
  };

  config = lib.mkIf cfg.enable (
    let
      packageWithPlugins = pkgs.xfce.thunar.override {
        thunarPlugins = cfg.plugins;
      };
      package = packageWithPlugins.overrideAttrs (oldAttrs: {
        configureFlags = (oldAttrs.configureFlags or [ ]) ++ cfg.configureFlags;
      });
    in
    {
      environment.systemPackages = [
        package
      ];

      services.dbus.packages = [
        package
      ];

      systemd.packages = [
        package
      ];

      programs.xfconf.enable = true;
    }
  );
}
