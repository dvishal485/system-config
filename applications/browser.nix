{
  pkgs,
  ...
}:

with pkgs;
{
  environment.systemPackages = with pkgs; [
    floorp-bin
  ];
}
