{ config, lib, pkgs, pkgs-unstable, ... }:

{
  home.username = "seattle";
  home.homeDirectory = "/home/seattle";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # essential
    wget
    curl
    tree
    terminus-nerdfont
    ripgrep

    # programming lang support
    pkg-config
    gcc
    go
    libffi

    # tools and utils
    btop
    ouch
    podman-compose
    pkgs-unstable.podman-desktop
    bat
    typst

    # personal usecase
    kdePackages.kate
    # kdePackages.kdeconnect-kde # drains phone battery
    stremio
    localsend
    gitui # will use w nvim
    google-chrome
    signal-desktop
    obsidian
    pdfslicer

    # python packages
    (python312.withPackages (ps: with ps; [
      pip
    ]))
  ];

  home.sessionVariables = {
    PKG_CONFIG_PATH = "${pkgs.libffi.dev}/lib/pkgconfig:$PKG_CONFIG_PATH";
    LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [ pkgs.libffi ]}:$LD_LIBRARY_PATH";
  };

  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
  };

  programs.git = {
    enable = true;
    diff-so-fancy.enable = true;

    userName = "dvishal485";
    userEmail = "26341736+dvishal485@users.noreply.github.com";

    extraConfig = {
      init.defaultBranch = "main";
    };

    signing = {
      signByDefault = true;
      key = "899004706F0BF896B7A19A69C5074BFBC4AD6B5C";
    };
  };

  programs.starship = {
      enable = true;
      enableBashIntegration = true;
  };

  programs.bash = {
    enable = true;
    historyControl = [ "ignoredups" ];
    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
      "cdspell"
    ];
    profileExtra = ''
      ssh-add ~/.ssh/id_ed25519
    '';

    # shell alias saves the day
    shellAliases = {
      cd = "cdi"; # make cd zoxide interactive by default (if multiple entries)
      g = "gitui";

      # my cat is batman
      # ah, well, i would like to use both whenever i feel like, cat still useful
      # cat = "bat";

      # immich stuff
      docker = "podman";
      immich-start = "podman pod start pod_immich";
      immich-stop = "podman pod stop pod_immich";

      # clean old gen
      nix-clean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";

      # remove conflicting firefox backup file and build
      nix-make = "sudo nixos-rebuild switch";
    };
  };

  # smarter cd zoxide with shell alias to enable interactive by default cd
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };

  home.stateVersion = "24.05";
}
