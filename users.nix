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
  };

  nix.settings.trusted-users = [ "seattle" ];
}
