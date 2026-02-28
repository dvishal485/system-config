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

  # Ensure gnome-keyring SSH agent socket is used system-wide
  # This socket is created by gnome-keyring-daemon --start --components=ssh
  environment.sessionVariables.SSH_AUTH_SOCK = "/run/user/\${UID}/keyring/ssh";
}
