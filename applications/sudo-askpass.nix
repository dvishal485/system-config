{
  pkgs,
  lib,
  config,
  ...
}:
let
  gui-askpass =
    prompt:
    if config.programs.ssh.enableAskPassword then
      "${config.programs.ssh.askPassword} '${prompt}'"
    else
      "${pkgs.zenity}/bin/zenity --password --title='${prompt}'";
  wrapped-askpass =
    prompt:
    pkgs.writeScriptBin "sudo-askpass" ''
      #!/usr/bin/env sh
      ${gui-askpass prompt} || (read -s -p 'Input Password: ' password && echo $password && unset password)
    '';
in
{
  environment.sessionVariables = {
    SUDO_ASKPASS =
      let
        prompt = "Input password for elevated privilages";
      in
      "${wrapped-askpass prompt}/bin/sudo-askpass";
    NH_SUDO_ASKPASS = lib.mkIf config.programs.nh.enable (
      let
        prompt = "Input password to give nh elevated privilages";
      in
      "${wrapped-askpass prompt}/bin/sudo-askpass"
    );
  };
}
