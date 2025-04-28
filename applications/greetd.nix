{ pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet -g 'hello world!' --asterisks -tr --user-menu";
      };
    };
  };
}
