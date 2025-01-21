{ ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.seattle = {
    isNormalUser = true;
    description = "seattle";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "render"
      "input"
    ];
    # mkpasswd
    initialHashedPassword = "$y$j9T$xCrQ/y8QdA98WfWGNukxi.$0tH8qGrpoudbxf3saZRK07i0bISuTmNWYQAMzKnmST6";
  };

  nix.settings.trusted-users = [ "seattle" ];
}
