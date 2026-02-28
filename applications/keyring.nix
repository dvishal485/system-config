{
  pkgs,
  ...
}:
{
  services.dbus.enable = true;
  services.dbus.packages = with pkgs; [
    libsecret
    gcr_4
    kdePackages.kwallet
  ];

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  # Enable SSH keys management in Seahorse
  programs.ssh.enableAskPassword = true;

  environment.systemPackages = with pkgs; [
    libsecret
    gcr_4
    kdePackages.kwalletmanager
    kdePackages.kwallet
    gnome-keyring # Ensure gnome-keyring is available for manual daemon start if needed
  ];
}
