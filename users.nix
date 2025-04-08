{ pkgs, ... }:
{
  users.mutableUsers = false;

  users.users.seattle = {
    isNormalUser = true;
    description = "seattle";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "render"
      "input"
      "kvm"
    ];
    # mkpasswd
    hashedPassword = "$y$j9T$xCrQ/y8QdA98WfWGNukxi.$0tH8qGrpoudbxf3saZRK07i0bISuTmNWYQAMzKnmST6";
    shell = pkgs.zsh;
  };

  users.users.root.hashedPassword = "$y$j9T$oqdHdJ/GL1YU2BtwlxBZs/$IHFaux867G8XT5yw3p2DNPv049Rv1aZMcZec6UI5kN7";

  nix.settings.trusted-users = [ "seattle" ];
}
