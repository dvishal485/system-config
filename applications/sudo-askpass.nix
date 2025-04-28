{ pkgs, config, ... }:
let
  prompt = "Input password for elevated privilages";
  gui-askpass =
    if config.programs.ssh.enableAskPassword then
      "${config.programs.ssh.askPassword} '${prompt}'"
    else
      "${pkgs.zenity}/bin/zenity --password --title='${prompt}'";
  wrapped-askpass = pkgs.writeScriptBin "sudo-askpass" ''
    #!/usr/bin/env sh
    ${gui-askpass} || (read -s -p 'Input Password: ' password && echo $password && unset password)
  '';
in
{
  environment.sessionVariables = {
    SUDO_ASKPASS = "${wrapped-askpass}/bin/sudo-askpass";
  };
}
