{ pkgs, ... }:
{
  hardware.graphics.enable32Bit = true;
  environment.systemPackages = with pkgs; [
    gamescope
    (lutris.override {
      extraPkgs = pkgs: [ ];
    })
  ];
}
