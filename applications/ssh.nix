{ pkgs, ... }:
{
  programs.ssh = {
    startAgent = false;
    enableAskPassword = true;
    askPassword = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
  };

  # SSH_ASKPASS_REQUIRE=prefer means SSH will try to use askpass when available
  # but won't require it. This works with gnome-keyring SSH agent integration.
  environment.variables.SSH_ASKPASS_REQUIRE = "prefer";

  # Set SSH_AUTH_SOCK to gnome-keyring's SSH socket at session startup
  # This runs during shell initialization and properly expands $UID
  environment.extraInit = ''
    if [ -z "$SSH_AUTH_SOCK" ]; then
      export SSH_AUTH_SOCK="/run/user/$UID/keyring/ssh"
    fi
  '';
}
