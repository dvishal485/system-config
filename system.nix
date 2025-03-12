{ pkgs, ... }:
{
  boot.supportedFilesystems = [
    "ntfs"
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

  services.journald.extraConfig = "SystemMaxUse=256M";
  systemd.services.asus-fan-mode = {
    description = "Set Asus Laptop Fan Mode to Performance Mode";
    wantedBy = [ "multi-user.target" ];
    script = ''
      echo "0x00110019" > /sys/kernel/debug/asus-nb-wmi/dev_id &&
      echo "2" > /sys/kernel/debug/asus-nb-wmi/ctrl_param &&
      cat /sys/kernel/debug/asus-nb-wmi/devs || true
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = false;
    };
  };

  # https://nix.dev/manual/nix/2.18/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet -g 'hello world!' --asterisks -tr --user-menu";
      };
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
