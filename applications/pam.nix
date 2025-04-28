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

    greetd = {
      enableGnomeKeyring = true;
      kwallet = {
        enable = true;
        package = pkgs.kwallet-pam;
        forceRun = true;
      };
    };
  };
}
