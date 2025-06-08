{
  lib,
  ...
}:
{
  specialisation = {
    remote-access.configuration = {
      system.nixos.tags = [ "remote-access" ];
      environment.etc."specialisation".text = "remote-access";

      imports = [
        ../../../applications/tailscale.nix
      ];

      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = true;
          UseDns = true;
          X11Forwarding = false;
          PermitRootLogin = "no";
        };
      };
    };
  };
}
