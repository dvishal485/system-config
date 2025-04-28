{ pkgs, ... }:
{
  boot.supportedFilesystems = [
    "btrfs"
  ];

  boot.kernel.sysctl = {
    "kernel.panic" = 10;
  };

  # install flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.journald.extraConfig = "SystemMaxUse=32M";

  # https://nix.dev/manual/nix/2.18/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;
  services.xserver.displayManager.sessionCommands = ''
    export SSH_AUTH_SOCK
  '';

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
