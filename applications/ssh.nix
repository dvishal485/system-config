{ pkgs, ... }:
{
  programs.ssh = {
    startAgent = false;
    enableAskPassword = true;
    askPassword = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
  };

  environment.variables.SSH_ASKPASS_REQUIRE = "prefer";
}
