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

    # VLC wrapped to use NVIDIA GPU for hardware decoding
    (pkgs.symlinkJoin {
      name = "vlc";
      paths = [ pkgs.vlc ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/vlc \
          --set __NV_PRIME_RENDER_OFFLOAD 1 \
          --set __NV_PRIME_RENDER_OFFLOAD_PROVIDER NVIDIA-G0 \
          --set __GLX_VENDOR_LIBRARY_NAME nvidia \
          --set __VK_LAYER_NV_optimus NVIDIA_only \
          --set LIBVA_DRIVER_NAME nvidia \
          --set NVD_BACKEND direct
        mv $out/share/applications/vlc.desktop{,.orig}
        substitute $out/share/applications/vlc.desktop{.orig,} \
          --replace-fail Exec=${pkgs.vlc}/bin/vlc Exec=$out/bin/vlc
      '';
    })

    transmission_4-gtk
    rclone
    mongodb-compass
    # wayvnc

    neohtop
  ];
}
