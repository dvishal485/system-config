{ config, lib, pkgs, pkgs-unstable, ... }:

{
  home.username = "seattle";
  home.homeDirectory = "/home/seattle";
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    # essential
    git
    neovim
    wget
    curl
    terminus-nerdfont
    python3
    ripgrep
    gcc

    # works well
    kdePackages.kate
    kdePackages.kwallet

    # tools and utils
    btop
    ouch
    podman-compose
    pkgs-unstable.podman-desktop
    bat

    # personal usecase
    stremio
    localsend
    gitui # will use w nvim
    google-chrome
    signal-desktop
  ];

  programs.git = {
    enable = true;
    diff-so-fancy.enable = true;

    userName = "dvishal485";
    userEmail = "26341736+dvishal485@users.noreply.github.com";

    extraConfig = {
      init.defaultBranch = "main";
    };
  };

    # customize firefox - system level (configuration.nix) + user level
    programs.firefox = {
      enable = true;
      profiles = {
        default = {
          id = 0;
          name = "default";
          isDefault = true;
          settings = {
            # "browser.startup.homepage" = "https://duckduckgo.com";
            "browser.search.defaultenginename" = "DuckDuckGo";
            "browser.search.order.1" = "DuckDuckGo";

            # "widget.use-xdg-desktop-portal.file-picker" = 1;
            # "browser.aboutConfig.showWarning" = false;
            # "browser.compactmode.show" = true;
            # "browser.cache.disk.enable" = false;
          };
          bookmarks = [
            {
              name = "NixOS Packages";
              toolbar = true;
              bookmarks = [
                {
                  name = "NixOS Packages";
                  url = "https://search.nixos.org/packages";
                }
                {
                  name = "Appendix A";
                  url = "https://nix-community.github.io/home-manager/options.xhtml";
                }
              ];
            }
          ];
          containers = {
            Personal = {
              color = "blue";
              icon = "fingerprint";
              id = 1;
            };
            College = {
              color = "orange";
              icon = "briefcase";
              id = 2;
            };
	    Youtube = {
              color = "red";
              icon = "chill";
              id = 3;
	    };
          };
          search = {
            force = true;
            default = "DuckDuckGo";
            order = [ "DuckDuckGo" "Google" ];
          };
        };
      };
    };

  programs.bash = {
    enable = true;
    historyControl = ["ignoredups"];
    sessionVariables = {
      FIREFOX_CFG = "\${HOME}/.mozilla/firefox";
    };
    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
      "cdspell"
    ];

    # shell alias saves the day
    shellAliases = {
      vi = "nvim";
      cd = "cdi"; # make cd zoxide interactive by default (if multiple entries)
      cat = "bat"; # my cat is batman

      # immich stuff
      docker = "podman";
      immich-start="podman pod start pod_immich";
      immich-stop="podman pod stop pod_immich";

      # clean old gen
      nix-clean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";

      # remove conflicting firefox backup file and build
      nix-make = "ls \${FIREFOX_CFG} | rg \"\\.backup\" | sed 's/.backup//g' | xargs -I \"{}\" mv \${FIREFOX_CFG}/{}.backup \${FIREFOX_CFG}/{}.bak && sudo nixos-rebuild switch";
    };
  };

  # smarter cd zoxide with shell alias to enable interactive by default cd
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    options = ["--cmd cd"];
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };

  home.stateVersion = "24.05";
}
