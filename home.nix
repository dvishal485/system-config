{ config, lib, pkgs, pkgs-unstable, ... }:

{
  home.username = "seattle";
  home.homeDirectory = "/home/seattle";
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    kdePackages.kate
    kdePackages.kwallet
    git
    neovim
    wget
    curl
    terminus-nerdfont
    python3
    ripgrep
    gcc
    btop
    ouch
    podman-compose
    pkgs-unstable.podman-desktop
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

#   programs.firefox = {
#     enable = true;
#     profiles = {
#       default = {
#           id = 0;
#           name = "default";
#           isDefault = true;
#
#       };
#     };
#   };

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
    shellAliases = {
      docker = "podman";
      vi = "nvim";
    };
  };

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
