{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.btrfs-simple-snapshot.nixosModules.default
  ];

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };

  services.btrfs-simple-snapshot = {
    enable = true;
    tasks =
      let
        mount_point = "/var/tmp/btrfs-simple-snapshot";
      in
      [
        {
          pre-cmd = ''
            ${pkgs.coreutils}/bin/mkdir -p ${mount_point}
            ${pkgs.util-linux}/bin/mount -o noatime -o compress=zstd /dev/disk/by-label/nixroot ${mount_point}
          '';
          post-cmd = ''
            ${pkgs.util-linux}/bin/umount ${mount_point}
            ${pkgs.coreutils}/bin/rm -r ${mount_point}
          '';
          mount-point = mount_point;
          subvolume = "home";
          snapshot-path = "backups";
          snapshot = {
            enable = true;
            args = {
              readonly = true;
              suffix-format = "%Y-%m-%d-%H.%M.%S";
              prefix = null;
            };
          };
          cleanup = {
            enable = true;
            args = {
              keep-count = 10;
              keep-since = "1 week";
            };
          };
        }
      ];
    config = {
      verbose = true;
      interval = "daily";
    };
  };

  nix.settings = {
    substituters = [
      "https://btrfs-simple-snapshot.cachix.org"
    ];
    trusted-public-keys = [
      "btrfs-simple-snapshot.cachix.org-1:fzqd4nDTzaoXe0sPf/y0lrrz/sm9kyJhuYt87hRMb58="
    ];
  };
}
