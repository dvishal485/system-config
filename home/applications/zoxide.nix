_: {
  # smarter cd zoxide with shell alias to enable interactive by default cd
  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };
}
