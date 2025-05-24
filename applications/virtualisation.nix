{ config, ... }:
{
  virtualisation.containers.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = !config.virtualisation.docker.enable;
    defaultNetwork.settings.dns_enabled = true;
    autoPrune.enable = true;
  };

  virtualisation.docker = {
    enable = false;
    storageDriver = "btrfs";
    enableOnBoot = false;
    autoPrune.enable = true;
  };

  hardware.nvidia-container-toolkit.enable = true;
}
