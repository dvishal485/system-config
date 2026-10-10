{ pkgs, ... }:
let
  # Signal command line arguments
  commandLineArgs = [
    "--password-store=kwallet6"
    "--ozone-platform=wayland"
  ];
in
{
  home.packages = [
    (pkgs.signal-desktop.override {
      commandLineArgs = builtins.toString commandLineArgs;
    })
  ];
}
