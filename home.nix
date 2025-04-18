{
  pkgs,
  pkgs-unstable,
  ...
}:
{
  imports = [
    ./home-config-files.nix
  ];

  home.username = "seattle";
  home.homeDirectory = "/home/seattle";
  home.shellAliases =

    {
      rm = "rmtrash";
      g = "lazygit";
      bt = "bluetooth";
      zed = "zeditor";
      z = "zeditor";

      # sorry vim
      vi = "hx";
      vim = "hx";

      # my cat is batman
      # ah, well, i would like to use both whenever i feel like, cat still useful
      # cat = "bat";
    };
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # essential
    wget
    curl
    tree
    ripgrep
    fd
    gitui
    lazygit
    ouch
    rmtrash

    # programming lang support
    vscode-fhs

    # tools and utils
    jq
    dconf-editor
    scrcpy
    htop
    gnome-system-monitor
    podman-compose
    podman-desktop
    bat
    typst
    tinymist
    libnotify
    gimp
    android-tools
    pkgs-unstable.devbox
    pkgs-unstable.d2
    # wayvnc

    # no worky on 24.11 as unstable branch got a breaking change w gbm driver path
    pkgs-unstable.neohtop

    # personal usecase
    gnome-text-editor
    pkgs-unstable.spotube
    viewnior
    kdePackages.okular
    stremio
    pkgs-unstable.zed-editor
    localsend
    google-chrome
    signal-desktop
    obsidian
    xournalpp
    pdfslicer
    onlyoffice-bin
    whatsapp-for-linux
    telegram-desktop
    mpv
    transmission_4-gtk

    # dict
    aspell
    hunspell
    hunspellDicts.en_US
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science

    # kdePackages.kdeconnect-kde # drains phone battery
    mongodb-compass
  ];

  programs.obs-studio.enable = true;

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
      core.editor = "hx";
      core.excludesFile = "$HOME/.config/.gitignore";
    };

    signing = {
      signByDefault = true;
      key = "899004706F0BF896B7A19A69C5074BFBC4AD6B5C";
    };

    delta = {
      enable = true;
      options = {
        "side-by-side" = true;
        "line-numbers" = true;
      };
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
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    history = {
      save = 50000;
      expireDuplicatesFirst = true;
      share = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "sudo" # hit Esc twice
      ];
    };
    initExtra = ''
      eval "$(devbox global shellenv --init-hook)"
    '';
  };

  programs.bash = {
    enable = true;
    historyControl = [
      "erasedups"
      "ignorespace"
    ];
    historyIgnore = [
      "exit"
      "shutdown"
      "reboot"
    ];
    historySize = 50000;
    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
      "cdspell"
    ];
    bashrcExtra = ''
      set -h && eval "$(devbox global shellenv --init-hook)"
    '';
  };

  # smarter cd zoxide with shell alias to enable interactive by default cd
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.helix = {
    enable = true;
    package = pkgs-unstable.evil-helix;
    defaultEditor = true;
    settings = {
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
        evil = true;
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  #programs.vscode = {
  #  enable = true;
  #  package = pkgs.vscode;
  #};

  home.stateVersion = "24.05";
}
