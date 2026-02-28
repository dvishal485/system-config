{
  pkgs,
  config,
  lib,
  ...
}:
{

  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user.name = "Vishal Das";
      user.email = "26341736+dvishal485@users.noreply.github.com";

      init.defaultBranch = "main";
      url = {
        "ssh://git@github.com/".insteadOf = "https://github.com/";
      };
      core.editor = "hx";
      core.excludesFile =
        lib.mkIf config.programs.config-dotfiles.sources.".gitignore".enable
          "${config.xdg.configHome}/.gitignore";
    };

    signing = {
      signByDefault = true;
      key = "899004706F0BF896B7A19A69C5074BFBC4AD6B5C";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      "side-by-side" = true;
      "line-numbers" = true;
    };
  };

  home.packages = with pkgs; [
    lazygit
    gitui
  ];

  home.shellAliases = {
    g = "lazygit";
  };
}
