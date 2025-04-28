{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "Vishal Das";
    userEmail = "26341736+dvishal485@users.noreply.github.com";

    extraConfig = {
      init.defaultBranch = "main";
      url = {
        "ssh://git@github.com/".insteadOf = "https://github.com/";
      };
      core.editor = "hx";
    };

    signing = {
      signByDefault = true;
      key = "899004706F0BF896B7A19A69C5074BFBC4AD6B5C";
    };

    delta = {
      enable = true;
      options = {
        "side-by-side" = true;
        "line-numbers" = true;
      };
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
