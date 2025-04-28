{
  pkgs,
  pkgs-unstable,
  ...
}:
{
  imports = [
    ./git.nix
    ./dotfiles.nix
    ../../applications/shell.nix
    ../../applications/direnv.nix
    ../../applications/zoxide.nix
    ../../applications/starship.nix
    ../../applications/helix.nix
    ../../applications/fzf.nix
    ../../applications/obs-studio.nix
    ../../applications/hyprshot.nix
    ../../applications/dictionary.nix
  ];

  home.sessionVariables = {
    SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
    GNOME_KEYRING_CONTROL = "/run/user/1000/keyring";
  };

  home.packages = with pkgs; [
    ouch
    rmtrash
    vscode-fhs
    scrcpy
    gnome-system-monitor
    podman-compose
    podman-desktop
    bat
    typst
    tinymist
    gimp
    qalculate-gtk
    nwg-look
    gnome-calendar
    android-tools
    pkgs-unstable.devbox
    pkgs-unstable.d2
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
    mongodb-compass
    # wayvnc

    # no worky on 24.11 as unstable branch got a breaking change w gbm driver path
    pkgs-unstable.neohtop
  ];
}
