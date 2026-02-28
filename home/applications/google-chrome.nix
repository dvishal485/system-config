{ pkgs, ... }:
let
  # Chrome command line arguments for better integration
  # Uses kwallet for password storage and enables Wayland features
  commandLineArgs = [
    "--password-store=kwallet6"
    "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder"  # Hardware video acceleration
    "--disable-features=UseChromeOSDirectVideoDecoder"  # Don't use ChromeOS decoder
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
