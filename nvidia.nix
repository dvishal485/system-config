{
  pkgs,
  config,
  lib,
  kernel,
  ...
}:
{
  # Nvidia Configuration
  services.xserver.videoDrivers = [ "nvidia" ];

  environment.sessionVariables.LIBVA_DRIVER_NAME = "nvidia";
  environment.sessionVariables.NVD_BACKEND = "direct";

  environment.systemPackages = [ pkgs.libva-utils ];
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      libva-vdpau-driver
    ];
  };

  hardware.nvidia = {
    # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      # Make sure to use the correct Bus ID values for your system!
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:4:0:0";
    };

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;
    nvidiaPersistenced = true;

    # changed in commit 4d711bc9394a61f804fb6e4aa0e04fadd642fa73
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/nvidia-x11/default.nix
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  specialisation = {
    nvidia-sync-mode.configuration = {
      system.nixos.tags = [ "nvidia-sync-mode" ];
      hardware.nvidia = {
        prime.offload.enable = lib.mkForce false;
        prime.offload.enableOffloadCmd = lib.mkForce false;
        prime.sync.enable = lib.mkForce true;
      };
    };
  };

  nix.settings = {
    substituters = [ "https://cuda-maintainers.cachix.org" ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };
}
