{ lib, config, ... }:
{
  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };
  services.blueman.enable = true;

  # Enable networking
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

  networking.firewall.allowedTCPPorts =
    [
      2283 # immich
    ]
    ++ [
      #vite
      5173
      4173
    ]
    ++ lib.optionals config.services.ollama.enable [ 11434 ]
    ++ lib.optionals config.services.openssh.enable [ 22 ];

  networking.firewall.allowedTCPPortRanges = [
    # kde connect
    # {
    #   from = 1714;
    #   to = 1764;
    # }

    # usual dev ports
    {
      from = 3000;
      to = 3005;
    }
    {
      from = 8000;
      to = 8005;
    }
  ];

  # file sharing https://nixos.org/manual/nixos/stable/#module-services-samba-configuring-file-share

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
}
