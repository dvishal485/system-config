{
  pkgs,
  config,
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
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    dynamicBoost.enable = true;

    nvidiaSettings = true;
    nvidiaPersistenced = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

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

    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/nvidia-x11/default.nix
    package = config.boot.kernelPackages.nvidiaPackages.production;
    # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #   version = "570.133.07";
    #   sha256_64bit = "sha256-LUPmTFgb5e9VTemIixqpADfvbUX1QoTT2dztwI3E3CY=";
    #   sha256_aarch64 = "sha256-yTovUno/1TkakemRlNpNB91U+V04ACTMwPEhDok7jI0=";
    #   openSha256 = "sha256-9l8N83Spj0MccA8+8R1uqiXBS0Ag4JrLPjrU3TaXHnM=";
    #   settingsSha256 = "sha256-XMk+FvTlGpMquM8aE8kgYK2PIEszUZD2+Zmj2OpYrzU=";
    #   persistencedSha256 = "sha256-G1V7JtHQbfnSRfVjz/LE2fYTlh9okpCbE4dfX9oYSg8=";
    # };
  };

  nix.settings = {
    substituters = [ "https://cuda-maintainers.cachix.org" ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };
}
