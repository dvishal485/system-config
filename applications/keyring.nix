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

  environment.systemPackages = with pkgs; [
    libsecret
    gcr_4
    kdePackages.kwalletmanager
    kdePackages.kwallet
  ];
}
