{ pkgs, ... }:
{
  # Floorp runs on AMD iGPU for suspend/resume stability.
  # Use `nvidia-offload floorp` manually if dGPU rendering is needed.
  environment.systemPackages = [ pkgs.floorp-bin ];
}
