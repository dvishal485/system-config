{ pkgs, ... }:
{
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      # Enable NVIDIA hardware encoding support (NVENC)
      obs-nvfbc  # NVIDIA Frame Buffer Capture (better performance than X11 capture)
    ];
  };

  # Create a wrapper to run OBS with NVIDIA GPU for better encoding performance
  home.packages = [
    (pkgs.writeShellScriptBin "obs-nvidia" ''
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec ${pkgs.obs-studio}/bin/obs "$@"
    '')
  ];
}
