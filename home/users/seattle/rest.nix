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
  ];

  home.packages = with pkgs; [
    # essential
    wget
    curl
    tree
    ripgrep
    fd
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

  #programs.vscode = {
  #  enable = true;
  #  package = pkgs.vscode;
  #};

}
