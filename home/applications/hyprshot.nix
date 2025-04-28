{ pkgs, ... }:
let
  hyprshot-notification = pkgs.writeScriptBin "hyprshot-notification" ''
    #!/usr/bin/env sh
    action=$(${pkgs.libnotify}/bin/notify-send "Screenshot saved" \
      "Screenshot saved to path $@" \
      -t 5000 -i "$@" -a Hyprshot \
      -A default=show -A dir='Show directory')

    if [[ "$action" == "default" ]]; then
      ${pkgs.xdg-utils}/bin/xdg-open "$@"
    elif [[ "$action" == "dir" ]]; then
      ${pkgs.xdg-utils}/bin/xdg-open "$(${pkgs.coreutils}/bin/dirname "$@")"
    fi
  '';
in
{
  home.packages = [
    hyprshot-notification
    pkgs.hyprshot
  ];

  home.sessionVariables = {
    HYPRSHOT_DIR = "$HOME/Pictures/Screenshots";
  };
}
