{
  pkgs,
  ...
}:
{
  security.pam.services = {
    sudo.nodelay = true;

    hyprlock = {
      nodelay = true;
      enableGnomeKeyring = true;
    };

    # Enable gnome-keyring unlock at login (greetd)
    # This unlocks all keyring components including SSH keys
    greetd = {
      enableGnomeKeyring = true;
      kwallet = {
        enable = true;
        package = pkgs.kdePackages.kwallet-pam;
        forceRun = true;
      };
    };

    # Also enable for login service as fallback
    login.enableGnomeKeyring = true;
  };
}
