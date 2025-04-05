{
  inputs,
  config,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    libsecret
  ];
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  services.dbus = {
    enable = true;
    # packages = [
    #   pkgs.seahorse # already added by programs.seahorse.enable
    # ];
  };

  # pam service
  security.pam.services = {
    sudo.nodelay = true;
    hyprlock = {
      nodelay = true;
      enableGnomeKeyring = true;
    };
    greetd.enableGnomeKeyring = true;
  };

  # home manager
  home-manager.users.seattle = {
    services.gnome-keyring = {
      enable = true;
      components = [
        "pkcs11"
        "secrets"
        "ssh"
      ];
    };

    systemd.user.sessionVariables = {
      SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
      GNOME_KEYRING_CONTROL = "/run/user/1000/keyring";
    };
  };
}
