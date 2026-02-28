{ pkgs, ... }:
{
  programs.ssh = {
    startAgent = false;
    enableAskPassword = true;
    askPassword = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
  };

  # SSH_ASKPASS_REQUIRE=prefer means SSH will try to use askpass when available
  # but won't require it. This works with gcr-ssh-agent integration.
  environment.variables.SSH_ASKPASS_REQUIRE = "prefer";

  # Set SSH_AUTH_SOCK to gcr-ssh-agent's socket at session startup
  # gcr-ssh-agent creates its socket at $XDG_RUNTIME_DIR/gcr/ssh
  # This replaces the deprecated gnome-keyring SSH agent socket
  environment.extraInit = ''
    if [ -z "$SSH_AUTH_SOCK" ]; then
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
    fi
  '';
}
