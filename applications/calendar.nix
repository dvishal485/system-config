{ pkgs, ... }:
{
  programs.dconf.enable = true;
  services.gnome.evolution-data-server.enable = true;
  # use this command to setup
  # XDG_CURRENT_DESKTOP=GNOME gnome-control-center
  services.gnome.gnome-online-accounts.enable = true;

  environment.systemPackages = [ pkgs.gnome-calendar ];
}
