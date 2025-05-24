{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.users.seattle = import ./default.nix;
    }
  ];

  programs.hyprland-full.users = [ "seattle" ];

  users.users.seattle = {
    uid = 1000;
    isNormalUser = true;
    description = "seattle";

    extraGroups =
      [
        "networkmanager"
        "wheel"
        "video"
        "render"
        "input"
        "kvm"
      ]
      ++ lib.optionals config.virtualisation.docker.enable [ "docker" ]
      ++ lib.optionals config.virtualisation.podman.enable [ "podman" ];

    useDefaultShell = true;

    # mkpasswd
    hashedPassword = "$y$j9T$xCrQ/y8QdA98WfWGNukxi.$0tH8qGrpoudbxf3saZRK07i0bISuTmNWYQAMzKnmST6";
  };
}
