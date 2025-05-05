{ pkgs, config, ... }:
let
  hyprshot-package = pkgs.hyprshot;
  hyprshot-dir = "${config.home.homeDirectory}/Pictures/Screenshots";
  custom-hyprshot = pkgs.writeScriptBin "hyprshot" ''
    #!/usr/bin/env sh

    hyprshot_notification() {
      local screenshot_path="$1"
      action=$(${pkgs.libnotify}/bin/notify-send "Screenshot saved" \
        "Screenshot saved to path $screenshot_path" \
        -t 5000 -i "$screenshot_path" -a Hyprshot \
        -A default=show -A dir='Show directory' -A delete='Delete')

      if [[ "$action" == "default" ]]; then
        ${pkgs.xdg-utils}/bin/xdg-open "$screenshot_path"
      elif [[ "$action" == "dir" ]]; then
        local dir=$(${pkgs.coreutils}/bin/dirname "$screenshot_path")
        ${pkgs.xdg-utils}/bin/xdg-open "$dir"
      elif [[ "$action" == "delete" ]]; then
        ${pkgs.coreutils}/bin/rm "$screenshot_path"
      fi
    }

    export -f hyprshot_notification

    HYPRSHOT_DIR=${hyprshot-dir} ${hyprshot-package}/bin/hyprshot "$@" -- "hyprshot_notification"
  '';
in
{
  home.packages = [
    custom-hyprshot
  ];
}
