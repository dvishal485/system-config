{
  pkgs,
  pkgs-unstable,
  ...
}:
{
  imports = [ ./neovim.nix ];

  home.username = "seattle";
  home.homeDirectory = "/home/seattle";
  programs.home-manager.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
  };

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
    jq
    dconf-editor
    scrcpy
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
    gnome-text-editor
    viewnior
    okular
    stremio
    zed-editor
    localsend
    google-chrome
    signal-desktop
    obsidian
    xournalpp
    pdfslicer
    onlyoffice-bin
    whatsapp-for-linux
    telegram-desktop
    vlc
    transmission_4-gtk

    # dict
    aspell
    hunspell
    hunspellDicts.en_US
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science

    # kdePackages.kdeconnect-kde # drains phone battery
  ];

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "Vishal Das";
    userEmail = "26341736+dvishal485@users.noreply.github.com";

    extraConfig = {
      init.defaultBranch = "main";
      url = {
        "ssh://git@github.com/".insteadOf = "https://github.com/";
      };
      core.editor = "zeditor";
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
      ssh-add
    '';

    # shell alias saves the day
    shellAliases = {
      g = "gitui";
      bt = "bluetooth";
      zed = "zeditor";
      z = "zeditor";

      # my cat is batman
      # ah, well, i would like to use both whenever i feel like, cat still useful
      # cat = "bat";

      # immich stuff
      immich-start = "podman pod start pod_immich";
      immich-stop = "podman pod stop pod_immich";
      immich-update = "podman compose up -d --force-recreate";
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
