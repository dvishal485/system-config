{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nvidia.nix
    ./network.nix
    ./fingerprint/default.nix
    ./power_mgmt.nix
    ./time_locale.nix
    ./system.nix
    ./bootloader.nix
    ./audio.nix
    ./users.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # enable virtualisation
  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  hardware.nvidia-container-toolkit.enable = true;

  # cuda by default
  # nixpkgs.config.cudaSupport = true;

  # services.ollama = {
  #   enable = true;
  #   acceleration = "cuda";
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
    gparted
    xclip
    wl-clipboard-rs
    firefox-wayland
    nix-index
  ];

  fonts.packages = with pkgs; [
    corefonts
    stix-two
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  programs.gnupg = {
    agent.enable = true;
    # agent.enableSSHSupport = true;
    agent.pinentryPackage = pkgs.pinentry-qt;
  };

  programs.nano.enable = false;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = ''
        set number relativenumber
        set tabstop=4
        set softtabstop=4
        set shiftwidth=4
        set expandtab

        set smartindent autoindent

        set incsearch hlsearch
        set termguicolors

        set scrolloff=12
      '';
    };
  };

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

}
