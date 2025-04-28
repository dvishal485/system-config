{
  lib,
  ...
}:
{
  specialisation = {
    nvidia-sync-mode.configuration = {
      system.nixos.tags = [ "nvidia-sync-mode" ];
      environment.etc."specialisation".text = "nvidia-sync-mode";
      hardware.nvidia = {
        prime.offload.enable = lib.mkForce false;
        prime.offload.enableOffloadCmd = lib.mkForce false;
        prime.sync.enable = lib.mkForce true;
      };
    };
  };
}
