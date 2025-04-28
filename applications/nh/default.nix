{
  inputs,
  config,
  pkgs,
  ...
}:
let
  nh = inputs.nh.packages.${pkgs.system}.nh;
  nh-patched = nh.overrideAttrs (
    finalAttrs: previousAttrs: {
      patches = previousAttrs.patches ++ [ ./nh-v4.0.2.patch ];
    }
  );
in
{
  programs.nh = {
    enable = true;
    package = nh-patched;
    flake = "/home/seattle/nix";
    clean = {
      enable = true;
      dates = "daily";
      extraArgs = "--keep-since 3d";
    };
  };

  environment.sessionVariables = {
    NH_FLAKE = config.programs.nh.flake;
  };
}
