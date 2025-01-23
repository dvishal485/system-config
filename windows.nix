{ pkgs, ... }:
{
  hardware.graphics.enable32Bit = true;
  environment.systemPackages = with pkgs; [
    (lutris.override {
      extraPkgs = pkgs: [ ];
    })
  ];
}
