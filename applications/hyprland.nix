_: {
  imports = [
    ../modules/hyprland
  ];

  # window compositor
  programs.hyprland-full = {
    enable = true;
    useFlake = false;
  };
}
