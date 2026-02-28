{
  pkgs,
  config,
  lib,
  ...
}:
let
  nvidiaPkg = config.hardware.nvidia.package;
  nvidiaPkg32 = nvidiaPkg.lib32 or null;
  vulkan32Path = if nvidiaPkg32 != null then "${nvidiaPkg32}/share/vulkan/icd.d/nvidia_icd.i686.json" else "";
in
{
  # NVIDIA Configuration for ASUS Vivobook Pro 15 M6500QF
  # GPU: NVIDIA GeForce RTX 2050 (Turing architecture)
  # TGP: 35W base, up to 50W with Dynamic Boost

  services.xserver.videoDrivers = [
    "nvidia"
    "amdgpu"
  ];

  # Kernel parameters for NVIDIA stability
  # NVreg_PreserveVideoMemoryAllocations: Preserves video memory across suspend/resume
  # NVreg_EnableGpuFirmware=0: Disables GSP firmware which can cause system freezes during media playback
  # NVreg_TemporaryFilePath: Use /tmp for temporary files to avoid filesystem issues
  boot.kernelParams = [
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "nvidia.NVreg_EnableGpuFirmware=0"
    "nvidia.NVreg_TemporaryFilePath=/tmp"
  ];

  # Video acceleration environment variables
  # These are set for system-wide hardware video acceleration
  environment.sessionVariables = {
    # NVIDIA video acceleration for most applications
    VDPAU_DRIVER = "nvidia";
    # VA-API driver for applications that use it (Firefox, Chrome, etc.)
    LIBVA_DRIVER_NAME = "nvidia";
    # NVIDIA decoder backend - 'direct' uses NVDEC directly
    NVD_BACKEND = "direct";
    # Allow applications to choose between GPUs
    # DRI_PRIME=1 will select the NVIDIA GPU for specific apps
    # Note: Hyprland and most desktop apps should use integrated AMD
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  # Wrapper script for GPU offloading to NVIDIA
  # This script wraps commands to run them on the NVIDIA GPU
  environment.systemPackages = with pkgs; [
    libva-utils
    nvtopPackages.nvidia
    (writeShellScriptBin "nvidia-offload" ''
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      # Vulkan ICD paths for NVIDIA
      # Primary 64-bit ICD file
      vkIcd="${nvidiaPkg}/share/vulkan/icd.d/nvidia_icd.x86_64.json"
      ${lib.optionalString (vulkan32Path != "") ''
      # Add 32-bit ICD for 32-bit application support
      if [ -f "${vulkan32Path}" ]; then
        vkIcd="$vkIcd:${vulkan32Path}"
      fi
      ''}
      export VK_ICD_FILENAMES="$vkIcd"
      exec "$@"
    '')
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # NVIDIA VA-API driver for hardware video acceleration
      nvidia-vaapi-driver
      # AMD ROCm for compute on iGPU
      rocmPackages.clr.icd
      # EGL Wayland support
      egl-wayland
      # Mesa VA-API driver for AMD iGPU fallback
      mesa.drivers
    ];
  };

  hardware.nvidia = {
    modesetting.enable = true;

    # Power management - enabled for laptop battery savings
    powerManagement.enable = true;
    # Fine-grained power management (RTX 2000 series supports this)
    # Allows GPU to completely power down when not in use
    powerManagement.finegrained = true;

    # Dynamic Boost - enables the GPU to draw more power when plugged in
    # RTX 2050 in this laptop supports 35W base up to 50W with boost
    dynamicBoost.enable = true;

    # Enable NVIDIA settings GUI for configuration
    nvidiaSettings = true;
    # Enable persistence daemon to keep GPU initialized
    nvidiaPersistenced = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      # PCI Bus IDs - obtained from lspci
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:4:0:0";
    };

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # RTX 2050 is Turing architecture - open modules are available but
    # proprietary is more stable currently
    open = false;

    # Use production driver for stability
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/nvidia-x11/default.nix
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # Fix nvidia-persistenced hanging during shutdown
  systemd.services.nvidia-persistenced = {
    serviceConfig = {
      TimeoutStopSec = "10s";
      KillMode = "process";
    };
  };

  # Add suspend/hibernate hooks for NVIDIA
  systemd.services.nvidia-resume = {
    description = "NVIDIA Resume Actions";
    after = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
    wantedBy = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
    script = ''
      # Restore NVIDIA power state after resume
      if [ -d /sys/bus/pci/devices/0000:01:00.0 ]; then
        echo "auto" > /sys/bus/pci/devices/0000:01:00.0/power/control 2>/dev/null || true
      fi
    '';
    serviceConfig = {
      Type = "oneshot";
    };
  };

  nix.settings = {
    substituters = [ "https://cuda-maintainers.cachix.org" ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };
}
