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

  home.sessionVariables = {
    SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
    GNOME_KEYRING_CONTROL = "/run/user/1000/keyring";
  };

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
    (pkgs.symlinkJoin {
      name = "stremio";
      paths = [ pkgs.stremio ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/stremio \
          --set LIBVA_DRIVER_NAME nvidia \
          --set NVD_BACKEND direct \
          --set DRI_PRIME 1
        mv $out/share/applications/smartcode-stremio.desktop{,.orig}
        substitute $out/share/applications/smartcode-stremio.desktop{.orig,} \
          --replace-fail Exec=stremio Exec=$out/bin/stremio
      '';
    })
    zed-editor
    localsend
    obsidian
    xournalpp
    rnote
    pdfslicer
    wasistlos
    telegram-desktop
    mpv
    (pkgs.symlinkJoin {
      name = "vlc";
      paths = [ pkgs.vlc ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/vlc \
          --set LIBVA_DRIVER_NAME nvidia \
          --set NVD_BACKEND direct \
          --set DRI_PRIME 1
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
