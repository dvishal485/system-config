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


  programs.ssh = {
    enableAskPassword = true;
    askPassword = lib.mkIf use_kwallet "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
  };
  environment.variables.SSH_ASKPASS_REQUIRE = lib.mkIf use_kwallet "prefer";

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
