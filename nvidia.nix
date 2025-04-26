{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
{
  # Nvidia Configuration
  services.xserver.videoDrivers = [
    "nvidia"
    "amdgpu"
  ];

  # this is what powerManagement does
  # boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

  # environment.sessionVariables.VDPAU_DRIVER = "nvidia";
  # environment.sessionVariables.LIBVA_DRIVER_NAME = "nvidia";
  # environment.sessionVariables.NVD_BACKEND = "direct";

  environment.systemPackages = [ pkgs.libva-utils ];
  hardware.graphics = {
    enable = true;
    # package = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system}.mesa.drivers;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      rocmPackages.clr.icd
      egl-wayland
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
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;
    dynamicBoost.enable = true;

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
    # package = config.boot.kernelPackages.nvidiaPackages.production;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "570.133.07";
      sha256_64bit = "sha256-LUPmTFgb5e9VTemIixqpADfvbUX1QoTT2dztwI3E3CY=";
      sha256_aarch64 = "sha256-yTovUno/1TkakemRlNpNB91U+V04ACTMwPEhDok7jI0=";
      openSha256 = "sha256-9l8N83Spj0MccA8+8R1uqiXBS0Ag4JrLPjrU3TaXHnM=";
      settingsSha256 = "sha256-XMk+FvTlGpMquM8aE8kgYK2PIEszUZD2+Zmj2OpYrzU=";
      persistencedSha256 = "sha256-G1V7JtHQbfnSRfVjz/LE2fYTlh9okpCbE4dfX9oYSg8=";
    };
  };

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
    gaming.configuration =
      let
        kernel = pkgs.linuxPackages_xanmod_latest;
      in
      {
        system.nixos.tags = [ "gaming" ];
        environment.etc."specialisation".text = "gaming";
        boot.kernelPackages = lib.mkForce kernel;
        programs.gaming.enable = lib.mkForce true;
      };
  };

  nix.settings = {
    substituters = [ "https://cuda-maintainers.cachix.org" ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };
}
