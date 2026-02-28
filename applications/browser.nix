{
  config,
  pkgs,
  lib,
  ...
}:

with pkgs;
let
  # Helper function to create a desktop entry that runs the app with nvidia-offload
  patchDesktop =
    pkg: appName: from: to:
    lib.hiPrio (
      pkgs.runCommand "nvidia-offload-${appName}" { } ''
        ${coreutils}/bin/mkdir -p $out/share/applications
        ${gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
      ''
    );
  GPUOffloadApp = pkg: desktopName: patchDesktop pkg desktopName "^Exec=" "Exec=nvidia-offload ";
in
{
  environment.systemPackages = with pkgs; [
    floorp-bin
    # Offload floorp to NVIDIA GPU for better video playback
    (lib.mkIf config.hardware.nvidia.prime.offload.enable (GPUOffloadApp floorp-bin "floorp"))
  ];
}
