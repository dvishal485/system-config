{
  pkgs,
  ...
}:
{
  services.dbus.enable = true;
  services.dbus.packages = with pkgs; [
    libsecret
    gcr_4
  ];

  programs.gnupg = {
    dirmngr.enable = true;
    agent = {
      enable = true;
      enableBrowserSocket = true;
      enableSSHSupport = false;
      pinentryPackage = pkgs.pinentry-gnome3;
    };
  };

  environment.systemPackages = with pkgs; [
    libsecret
    gcr_4
  ];
  programs.ssh = {
    startAgent = false;
    enableAskPassword = true;
    askPassword = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
  };
  environment.variables.SSH_ASKPASS_REQUIRE = "prefer";

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  # pam service
  security.pam.services = {
    sudo.nodelay = true;
    hyprlock = {
      nodelay = true;
      enableGnomeKeyring = true;
    };
    # login = {
    #   enableGnomeKeyring = true;
    # };
    greetd = {
      enableGnomeKeyring = true;
    };
  };

  # home manager
  home-manager.users.seattle = {
    # services.gnome-keyring = {
    #   enable = true;
    #   components = [
    #     "pkcs11"
    #     "secrets"
    #     "ssh"
    #   ];
    # };

    systemd.user.sessionVariables = {
      SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
      GNOME_KEYRING_CONTROL = "/run/user/1000/keyring";
    };
  };
}
