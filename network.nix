{ ... }:
{
  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };
  # services.blueman.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;

  networking.hostName = "seattle";
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

  networking.firewall.allowedTCPPorts = [
    2283
    5173
    4173
    11434 # ollama
  ];

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

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
}
