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
          # Security hardening for SSH
          PasswordAuthentication = true; # Allow password auth for convenience, consider disabling for prod
          UseDns = true;
          X11Forwarding = false; # Disable X11 forwarding for security
          PermitRootLogin = "no"; # Never allow root login
          # Additional security settings
          KbdInteractiveAuthentication = false; # Disable keyboard-interactive auth
          PermitEmptyPasswords = false; # Never allow empty passwords
          MaxAuthTries = 3; # Limit auth attempts
          LoginGraceTime = 30; # 30 second login timeout
          # Use only strong ciphers and MACs
          Ciphers = [
            "chacha20-poly1305@openssh.com"
            "aes256-gcm@openssh.com"
            "aes128-gcm@openssh.com"
          ];
          KexAlgorithms = [
            "curve25519-sha256"
            "curve25519-sha256@libssh.org"
          ];
          Macs = [
            "hmac-sha2-512-etm@openssh.com"
            "hmac-sha2-256-etm@openssh.com"
          ];
        };
        # Only allow specific users to connect
        allowSFTP = true;
      };

      # Fail2ban for SSH brute force protection
      services.fail2ban = {
        enable = true;
        maxretry = 5;
        bantime = "1h";
        bantime-increment = {
          enable = true;
          maxtime = "24h";
        };
      };
    };
  };
}
