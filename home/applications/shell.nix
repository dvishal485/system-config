_: {
  home.shellAliases = {
    rm = "rmtrash";
    bt = "bluetooth";
    zed = "zeditor";
    z = "zeditor";
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
}
