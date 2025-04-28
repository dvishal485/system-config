{ pkgs, ... }:
{
  home.packages = with pkgs; [
    aspell
    hunspell
    hunspellDicts.en_US
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
  ];
}
