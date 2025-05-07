{ pkgs, ... }:
let
  commandLineArgs = [ "--password-store=kwallet6" ];
in
{
  home.packages = [
    (pkgs.google-chrome.override {
      commandLineArgs = builtins.toString commandLineArgs;
    })
  ];
}
