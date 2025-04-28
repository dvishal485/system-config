_: {
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;

  networking.hostName = "rio";
  networking.dhcpcd.wait = "background";
  networking.networkmanager.wifi.backend = "wpa_supplicant";
  networking.networkmanager.logLevel = "OFF";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # NextDNS
  services.resolved = {
    enable = true;
    extraConfig = ''
      [Resolve]
      DNS=45.90.28.0#nixos-73c4d4.dns.nextdns.io
      DNS=2a07:a8c0::#nixos-73c4d4.dns.nextdns.io
      DNS=45.90.30.0#nixos-73c4d4.dns.nextdns.io
      DNS=2a07:a8c1::#nixos-73c4d4.dns.nextdns.io
      DNSOverTLS=yes
    '';
  };
}
