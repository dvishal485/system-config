{
  pkgs,
  pkgs-unstable,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./graphics.nix
    ./users.nix

    ./specialisations/gaming.nix
    # ./specialisations/nvidia-sync-mode.nix
    # ./specialisations/ollama.nix
    ./specialisations/remote-access.nix

    ../../applications/audio.nix
    ../../applications/network.nix
    ../../applications/firewall.nix
    ../../applications/bluetooth.nix
    # ../../applications/fingerprint.nix
    ../../applications/greetd.nix
    ../../applications/bootloader.nix
    ../../applications/polkit.nix

    ../../applications/time_locale.nix
    ../../applications/power_mgmt.nix
    ../../applications/asus-fan-mode.nix
    ../../applications/btrfs.nix
    ../../applications/pam.nix
    ../../applications/virtualisation.nix
    ../../applications/font.nix
    ../../applications/zsh.nix
    ../../applications/hyprland.nix

    ../../applications/gnupg.nix
    ../../applications/keyring.nix
    ../../applications/ssh.nix

    ../../applications/thunar.nix
    ../../applications/file-mngr-utils.nix
    ../../applications/calendar.nix
    ../../applications/comma.nix
    ../../applications/foot.nix
    ../../applications/sudo-askpass.nix
    ../../applications/nh.nix
    ../../applications/browser.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_6_12;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    util-linux
    lshw
    usbutils
    pciutils
    gnupg
    gnome-disk-utility
    evil-helix
    wl-clipboard
    libnotify
    wget
    curl
    httpie
    tree
    ripgrep
    fd
    jq
    sd
    htop
    tealdeer
    # dotool
    # uutils-coreutils-noprefix still a wip
  ];

  programs.nano.enable = false;

  programs.nix-ld.enable = true;
  services.fstrim.enable = true;
  services.printing.enable = true;
  services.xserver.enable = false;
  services.smartd = {
    enable = true;
    autodetect = true;
  };

  # https://nixos.wiki/wiki/Fwupd
  services.fwupd.enable = true;

  services.journald.extraConfig = "SystemMaxUse=32M";
  systemd.extraConfig = "DefaultTimeoutStopSec=18s";

  security.sudo.extraConfig = ''
    Defaults insults
  '';

  # cuda by default
  # nixpkgs.config.cudaSupport = true;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.05";

  nix.settings = {
    auto-optimise-store = true;

    experimental-features = [
      "nix-command"
      "flakes"
    ];

    substituters = [
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
    ];

    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };
}
