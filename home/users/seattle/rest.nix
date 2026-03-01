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
    ../../applications/wlsunset.nix
    ../../applications/google-chrome.nix
    ../../applications/signal.nix
    ../../applications/document-tools.nix
  ];

  # GNOME_KEYRING_CONTROL is set by gnome-keyring-daemon at startup
  # SSH_AUTH_SOCK is set system-wide in applications/ssh.nix

  home.packages = with pkgs; [
    just
    swayosd
    ouch
    rmtrash
    vscode-fhs
    scrcpy
    gnome-system-monitor
    podman-compose
    pkgs-unstable.podman # fix: use stable branch once electorn gets updated from EOL version
    bat
    typst
    tinymist
    gimp
    qalculate-gtk
    nwg-look
    android-tools
    devbox
    d2
    gnome-text-editor
    eog
    zed-editor
    localsend
    obsidian
    xournalpp
    rnote
    pdfslicer
    wasistlos
    telegram-desktop

    # MPV - configured in ~/.config/mpv/mpv.conf to use NVDEC
    mpv

    # VLC runs on AMD iGPU for suspend/resume stability.
    # Use `nvidia-offload vlc` manually if dGPU rendering is needed.
    vlc

    transmission_4-gtk
    rclone
    mongodb-compass
    # wayvnc

    neohtop
  ];
}
