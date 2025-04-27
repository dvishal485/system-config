{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    # nixpkgs.follows = "hyprland/nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    btrfs-simple-snapshot.url = "github:dvishal485/btrfs-simple-snapshot/v0.1.6";

    nh.url = "github:nix-community/nh/v4.0.2";
    nh.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-gaming.url = "github:fufexan/nix-gaming";

    hyprland.url = "git+https://github.com/hyprwm/hyprland?ref=refs/tags/v0.46.2&submodules=1";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nix-index-database,
      ...
    }:
    {
      nixosConfigurations.rio = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";

        specialArgs = {
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
          inherit inputs;
        };

        modules = [
          ./hosts/rio/configuration.nix
          nix-index-database.nixosModules.nix-index
          {
            programs.nix-index-database.comma.enable = true;
          }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              pkgs-unstable = import nixpkgs-unstable {
                inherit system;
                config.allowUnfree = true;
              };
              inherit inputs;
            };

            home-manager.users.seattle = import ./home/users/seattle;
            home-manager.backupFileExtension = "backup";
          }
        ];
      };
    };
}
