{ pkgs, ... }:
let
  # Chrome command line arguments for better integration
  # Uses kwallet for password storage and stable Wayland defaults
  commandLineArgs = [
    "--password-store=kwallet6"
    "--ozone-platform=wayland"
  ];
in
{
  home.packages = [
    (pkgs.google-chrome.override {
      commandLineArgs = builtins.toString commandLineArgs;
    })
  ];
}
