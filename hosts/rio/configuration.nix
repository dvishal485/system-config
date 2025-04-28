{
  inputs,
  pkgs,
  pkgs-unstable,
  lib,
  config,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./graphics.nix
    ./users.nix

    ../../hyprland.nix

    ./specialisations/gaming.nix
    ./specialisations/nvidia-sync-mode.nix
    # ./specialisations/ollama.nix

    ../../applications/audio.nix
    ../../applications/network.nix
    ../../applications/firewall.nix
    ../../applications/bluetooth.nix
    ../../applications/fingerprint.nix
    ../../applications/greetd.nix
    ../../applications/bootloader.nix

    ../../applications/time_locale.nix
    ../../applications/power_mgmt.nix
    ../../applications/asus-fan-mode.nix
    ../../applications/btrfs.nix
    ../../applications/pam.nix
    ../../applications/virtualisation.nix
    ../../applications/font.nix
    ../../applications/zsh.nix

    ../../applications/gnupg.nix
    ../../applications/keyring.nix
    ../../applications/ssh.nix

    ../../applications/thunar.nix
    ../../applications/comma.nix
    ../../applications/foot.nix
    ../../applications/sudo-askpass.nix
    ../../applications/nh
  ];

  boot.kernelPackages = pkgs.linuxPackages_6_12;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings.auto-optimise-store = true;

  nixpkgs.config.allowUnfree = true;

  services.journald.extraConfig = "SystemMaxUse=32M";

  # https://nix.dev/manual/nix/2.18/command-ref/conf-file.html#conf-auto-optimise-store

  services.printing.enable = true;
  services.xserver.enable = false;

  security.sudo.extraConfig = ''
    Defaults insults
  '';

  # cuda by default
  # nixpkgs.config.cudaSupport = true;

  # https://nixos.wiki/wiki/Fwupd
  services.fwupd.enable = true;

  services.fstrim.enable = true;

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
    pkgs-unstable.evil-helix
    wl-clipboard
    librewolf
    libnotify
    wget
    curl
    tree
    ripgrep
    fd
    jq
    htop
    # dotool
    # uutils-coreutils-noprefix still a wip
  ];


  # services.udev.extraRules =
  #   let
  #     mkRule = as: lib.concatStringsSep ", " as;
  #     mkRules = rs: lib.concatStringsSep "\n" rs;
  #   in
  #   mkRules [
  #     # fix /dev/uinput group
  #     # https://git.sr.ht/~geb/dotool/tree/HEAD/item/80-dotool.rules
  #     (mkRule [
  #       ''KERNEL=="uinput"''
  #       ''GROUP="input"''
  #       ''MODE="0620"''
  #       ''OPTIONS+="static_node=uinput"''
  #     ])
  #   ];


  programs.nix-ld.enable = true;

  programs.nano.enable = lib.mkForce false;
  programs.neovim.enable = lib.mkForce false;

  # flatpak specialization
  # specialisation = {
  #  flatpak.configuration = {
  #    system.nixos.tags = [ "flatpak" ];
  #    services.flatpak.enable = true;
  #  };
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  nix.settings = {
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
