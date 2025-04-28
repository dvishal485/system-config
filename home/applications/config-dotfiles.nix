# Genrates a symlink for files in the .config directory
# Author: @dvishal485
{ lib, config, ... }:
let
  cfg = config.programs.config-dotfiles;
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  username = config.home.username;
  configHome = config.xdg.configHome;

  configOpts =
    { name, config, ... }:
    {
      options = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable this configuration symlink";
        };

        sourceBase = lib.mkOption {
          type = lib.types.str;
          default = "${cfg.nixos-config-path}/home/users/${username}";
          defaultText = lib.literalMD "''${cfg.nixos-config-path}/users/''${config.home.username}";
          description = "Base source path for the configuration files";
        };

        sourcePath = lib.mkOption {
          type = lib.types.str;
          default = ".config/${name}";
          defaultText = lib.literalMD ".config/''${name}";
          description = "Source path for the configuration files at user level";
        };

        configPath = lib.mkOption {
          type = lib.types.str;
          default = configHome;
          defaultText = lib.literalMD "''${config.xdg.configHome}";
          description = "Target directory for the symlink";
        };

        target = lib.mkOption {
          type = lib.types.str;
          default = name;
          description = "Name of the symlink in target directory";
        };
      };
    };
in
{
  options.programs.config-dotfiles = {
    nixos-config-path = lib.mkOption {
      type = lib.types.path;
      default = "/etc/nixos";
      description = "Base path for NixOS configurations";
    };

    sources = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule configOpts);
      default = { };
      description = "Attribute set of configuration symlinks";
    };
  };

  config = {
    home.file = lib.mkMerge (
      lib.mapAttrsToList (
        name: sourceCfg:
        lib.mkIf sourceCfg.enable {
          "${sourceCfg.configPath}/${sourceCfg.target}".source = mkOutOfStoreSymlink "${sourceCfg.sourceBase}/${sourceCfg.sourcePath}";
        }
      ) cfg.sources
    );
    # Additional global configurations
    # home.file."${config.xdg.dataHome}/devbox/global/default/devbox.json".source =
    #   mkOutOfStoreSymlink "${cfg.nixos-config-path}/devbox/devbox-global.json";
    # home.file."${config.xdg.dataHome}/devbox/global/default/devbox.lock".source =
    #   mkOutOfStoreSymlink "${cfg.nixos-config-path}/devbox/devbox-global.lock";
  };
}
