{ pkgs, ... }:
{
  imports = [
    ./home/users/seattle/config.nix
  ];

  users.mutableUsers = false;
  users.defaultUserShell = pkgs.zsh;

  users.users.root.hashedPassword = "$y$j9T$oqdHdJ/GL1YU2BtwlxBZs/$IHFaux867G8XT5yw3p2DNPv049Rv1aZMcZec6UI5kN7";

  nix.settings.trusted-users = [ "seattle" ];
}
