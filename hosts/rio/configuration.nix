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
    ../../network.nix
    ../../fingerprint.nix
    ../../power_mgmt.nix
    ../../time_locale.nix
    ../../system.nix
    ../../bootloader.nix
    ../../audio.nix
    ../../users.nix
    ../../hyprland.nix
    ../../pam-keyring.nix

    ./specialisations/gaming.nix
    ./specialisations/nvidia-sync-mode.nix
    ../../applications/thunar.nix
    ../../android.nix
    inputs.btrfs-simple-snapshot.nixosModules.default
  ];

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };
  services.btrfs-simple-snapshot = {
    enable = true;
    tasks =
      let
        mount_point = "/var/tmp/btrfs-simple-snapshot";
      in
      [
        {
          pre-cmd = ''
            ${pkgs.coreutils}/bin/mkdir -p ${mount_point}
            ${pkgs.util-linux}/bin/mount -o noatime -o compress=zstd /dev/disk/by-label/nixroot ${mount_point}
          '';
          post-cmd = ''
            ${pkgs.util-linux}/bin/umount ${mount_point}
            ${pkgs.coreutils}/bin/rm -r ${mount_point}
          '';
          mount-point = mount_point;
          subvolume = "home";
          snapshot-path = "backups";
          snapshot = {
            enable = true;
            args = {
              readonly = true;
              suffix-format = "%Y-%m-%d-%H.%M.%S";
              prefix = null;
            };
          };
          cleanup = {
            enable = true;
            args = {
              keep-count = 10;
              keep-since = "1 week";
            };
          };
        }
      ];
    config = {
      verbose = true;
      interval = "daily";
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_6_12;
  # enable virtualisation
  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  hardware.nvidia-container-toolkit.enable = true;

  security.sudo.extraConfig = ''
    Defaults insults
  '';

  # cuda by default
  # nixpkgs.config.cudaSupport = true;

  # specialisation = {
  #   ollama.configuration = {
  #     system.nixos.tags = [ "ollama" ];
  #     services.ollama = {
  #       enable = true;
  #       acceleration = "cuda";
  #     };
  #   };
  # };

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
    # dotool
    # uutils-coreutils-noprefix still a wip
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    histSize = 10000;
  };

  environment.sessionVariables =
    let
      prompt = "Input password for elevated privilages";
      gui-askpass =
        if config.programs.ssh.enableAskPassword then
          "${config.programs.ssh.askPassword} '${prompt}'"
        else
          "${pkgs.zenity}/bin/zenity --password --title='${prompt}'";
      wrapped-askpass = pkgs.writeScriptBin "sudo-askpass" ''
        #!/usr/bin/env sh
        ${gui-askpass} || (read -s -p 'Input Password: ' password && echo $password && unset password)
      '';
    in
    {
      SUDO_ASKPASS = "${wrapped-askpass}/bin/sudo-askpass";
    };

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

  fonts.packages = with pkgs; [
    corefonts
    stix-two
    # https://github.com/NixOS/nixpkgs/blob/nixos-24.11/pkgs/data/fonts/nerdfonts/shas.nix
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    # nerd-fonts.jetbrains-mono
  ];

  programs.nh =
    let
      nh = inputs.nh.packages.${pkgs.system}.nh;
      nh-patched = nh.overrideAttrs (
        finalAttrs: previousAttrs: {
          patches = previousAttrs.patches ++ [ ./nh-v4.0.2.patch ];
        }
      );
    in
    {
      enable = true;
      package = nh-patched;
      flake = "/home/seattle/nix";
      clean = {
        enable = true;
        dates = "daily";
        extraArgs = "--keep-since 3d";
      };
    };

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
      "https://btrfs-simple-snapshot.cachix.org"
    ];

    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "btrfs-simple-snapshot.cachix.org-1:fzqd4nDTzaoXe0sPf/y0lrrz/sm9kyJhuYt87hRMb58="
    ];
  };
}
