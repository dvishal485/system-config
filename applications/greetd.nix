{ pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet -g 'hello world!' --asterisks -tr --user-menu --theme 'container=darkgray;border=lightblue'";
      };
    };
  };
}
