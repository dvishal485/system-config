{ lib, config, ... }:
{
  # for file sharing refer https://nixos.org/manual/nixos/stable/#module-services-samba-configuring-file-share

  networking.firewall.allowedTCPPorts =
    [
      2283 # immich
    ]
    ++ [
      # vite
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
}
