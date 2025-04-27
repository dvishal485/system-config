{ pkgs-unstable, ... }:
{
  programs.helix = {
    enable = true;
    package = pkgs-unstable.evil-helix;
    defaultEditor = true;
    settings = {
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
        evil = true;
      };
    };
  };

  # sorry vim
  home.shellAliases = {
    vi = "hx";
    vim = "hx";
  };
}
