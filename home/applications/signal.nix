{ pkgs, ... }:
let
  commandLineArgs = [ "--password-store=kwallet6" ];
in
{
  home.packages = [
    (pkgs.signal-desktop-bin.override {
      commandLineArgs = builtins.toString commandLineArgs;
    })
  ];
}
