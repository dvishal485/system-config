{
  inputs,
  config,
  pkgs,
  ...
}:
{
  programs.nh = {
    enable = true;
    package = inputs.nh.packages.${pkgs.stdenv.hostPlatform.system}.nh;
    flake = "/home/seattle/nix";
    clean = {
      enable = true;
      dates = "daily";
      extraArgs = "--keep-since 3d --nogcroots";
    };
  };

  environment.sessionVariables = {
    NH_FLAKE = config.programs.nh.flake;
    # NH_SUDO_ASKPASS configured in ./sudo-askpass.nix
  };
}
