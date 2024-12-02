{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  my-scrcpy = import ./scrcpy.nix {
    inherit (pkgs)
      lib
      stdenv
      fetchurl
      fetchFromGitHub
      makeWrapper
      meson
      ninja
      pkg-config
      runtimeShell
      installShellFiles
      ;
    inherit (pkgs)
      android-tools
      ffmpeg
      libusb1
      SDL2
      ;
  };
in
{
  imports = [ ./neovim.nix ];

  home.username = "seattle";
  home.homeDirectory = "/home/seattle";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # essential
    wget
    curl
    tree
    ripgrep
    fd
    gitui
    ouch

    # programming lang support
    pkg-config
    vscode-fhs

    # tools and utils
    my-scrcpy
    btop
    gnome-system-monitor
    podman-compose
    podman-tui
    bat
    typst
    tinymist
    alacritty
    libnotify
    gimp
    android-tools
    pkgs-unstable.devbox
    pkgs-unstable.d2

    # personal usecase
    kdePackages.kate
    stremio
    localsend
    google-chrome
    signal-desktop
    obsidian
    xournalpp
    pdfslicer
    onlyoffice-bin
    zapzap
    telegram-desktop
    vlc
    transmission_4-gtk
    # kdePackages.kdeconnect-kde # drains phone battery
  ];

  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    diff-so-fancy.enable = true;

    userName = "Vishal Das";
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
    settings = {
      command_timeout = 300;
      scan_timeout = 10;
      character = {
        success_symbol = "[\\$](bold green)";
        error_symbol = "[\\$](bold red)";
      };
    };
    enableBashIntegration = true;
  };

  programs.bash = {
    enable = true;
    historyControl = [
      "erasedups"
      "ignorespace"
    ];
    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
      "cdspell"
    ];
    profileExtra = ''
      eval "$(devbox global shellenv --init-hook)"
      # eval "$(devbox global shellenv --init-hook --install --no-refresh-alias --omit-nix-env=true)"
      ssh-add ~/.ssh/id_ed25519 2>/dev/null
    '';

    # shell alias saves the day
    shellAliases = {
      g = "gitui";
      bt = "bluetooth";

      # my cat is batman
      # ah, well, i would like to use both whenever i feel like, cat still useful
      # cat = "bat";

      # immich stuff
      immich-start = "podman pod start pod_immich";
      immich-stop = "podman pod stop pod_immich";
      immich-update = "podman compose up -d --force-recreate";

      # clean old gen
      nix-clean = "sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system && sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      nix-wipe = "sudo nix-collect-garbage -d && nix-collect-garbage -d";

      # build/update nixos
      nix-update = "sudo nixos-rebuild switch --update-input nixpkgs --flake . --upgrade";
      nix-make = "sudo nixos-rebuild switch";
    };
  };

  # smarter cd zoxide with shell alias to enable interactive by default cd
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  #programs.vscode = {
  #  enable = true;
  #  package = pkgs.vscode;
  #};

  home.stateVersion = "24.05";
}
