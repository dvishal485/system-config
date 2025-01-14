{ ... }:
{
  boot.supportedFilesystems = [
    "ntfs"
    "btrfs"
  ];

  # install flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.journald.extraConfig = "SystemMaxUse=256M";
  systemd.services.set-asus-fan-mode = {
    description = "Set Asus Laptop Fan Mode to Performance Mode";
    wantedBy = [ "multi-user.target" ];
    script = ''
      echo "0x00110019" > /sys/kernel/debug/asus-nb-wmi/dev_id &&
      echo "2" > /sys/kernel/debug/asus-nb-wmi/ctrl_param &&
      cat /sys/kernel/debug/asus-nb-wmi/devs || true
    '';
  };

  # https://nix.dev/manual/nix/2.18/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
