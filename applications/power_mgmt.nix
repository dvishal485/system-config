{ pkgs, lib, ... }:
{
  # Power savings
  powerManagement.enable = true;
  boot.resumeDevice = "/dev/disk/by-label/swap";

  # for intel cpu
  # services.thermald.enable = true;

  # disable ppd to enable tlp
  services.power-profiles-daemon.enable = lib.mkForce false;
  # tlp configurations: https://linrunner.de/tlp/settings/introduction.html
  services.tlp = {
    enable = true;
    settings = {
      # wifi power savings
      WIFI_PWR_ON_BAT = "off";
      WIFI_PWR_ON_AC = "off";

      DEVICES_TO_ENABLE_ON_STARTUP = "wifi";
      DEVICES_TO_ENABLE_ON_AC = "wifi";
      DEVICES_TO_DISABLE_ON_STARTUP = "wwan bluetooth";
      # DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = "bluetooth";

      # [ performance, balanced, low-power ] (not available on device)
      # PLATFORM_PROFILE_ON_AC = "performance";
      # PLATFORM_PROFILE_ON_BAT = "low-power";

      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # AMD performance policy
      # [ performance, balance_performance, default, balance_power, power ]
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # AMD Turbo core
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      AMDGPU_ABM_LEVEL_ON_AC = 0;
      # https://linrunner.de/tlp/settings/graphics.html#amdgpu-abm-level-on-ac-bat
      # resolves screen brightness surge on BAT leading to turn off display (fixed now)
      AMDGPU_ABM_LEVEL_ON_BAT = 1;

      # Optional helps save long term battery health
      # START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 60; # 60 and above it stops charging

      AHCI_RUNTIME_PM_ON_BAT = "auto";
      AHCI_RUNTIME_PM_ON_AC = "auto";
      AHCI_RUNTIME_PM_TIMEOUT = 30;

      RUNTIME_PM_ON_AC = "auto";
      RUNTIME_PM_ON_BAT = "auto";

      # USB autosuspend settings
      # Disable autosuspend for USB devices to prevent charging issues
      # Mobile phones connected for charging should not be suspended
      USB_AUTOSUSPEND = 1; # Enable autosuspend globally
      # Exclude phones/portable devices from autosuspend (these are typically class 0)
      # Format: list of VID:PID pairs or device types to exclude
      USB_EXCLUDE_PHONE = 1; # Exclude phones from autosuspend (TLP feature)

      # USB allowlist/denylist approach: only enable autosuspend for specific devices
      # By default, don't autosuspend any USB devices on AC power for better compatibility
      USB_AUTOSUSPEND_ON_AC = 0;
      USB_AUTOSUSPEND_ON_BAT = 1;

      # Exclude all devices that should not be autosuspended
      # USB hubs, keyboards, mice are handled automatically by TLP
      # Add specific exclusions for Android MTP/Charging devices
      USB_DENYLIST = ""; # Let TLP handle defaults
      USB_ALLOWLIST = ""; # Let TLP handle defaults
    };
  };

  # https://wiki.nixos.org/wiki/Power_Management
  services.udev.extraRules =
    let
      mkRule = as: lib.concatStringsSep ", " as;
      mkRules = rs: lib.concatStringsSep "\n" rs;
    in
    # targetMachine = "seattle@.host";
    mkRules [
      # hdd spin stop for laptop battery savings
      # Only apply aggressive power saving to rotational drives (HDD)
      # This helps preserve HDD health by reducing spin cycles
      (mkRule [
        ''ACTION=="add|change"''
        ''SUBSYSTEM=="block"''
        ''KERNEL=="sd[a-z]"''
        ''ATTR{queue/rotational}=="1"''
        ''RUN+="${pkgs.hdparm}/bin/hdparm -B 90 -S 41 /dev/%k"''
      ])

      # Disable USB autosuspend for Android devices in charging mode
      # This prevents the device from being disconnected during charging
      # Android devices typically use class ff (vendor specific) for MTP/charging
      # Class 00 is composite devices (common for phones)
      (mkRule [
        ''ACTION=="add"''
        ''SUBSYSTEM=="usb"''
        ''ATTR{bDeviceClass}=="00"''
        ''ATTR{bDeviceSubClass}=="00"''
        ''TEST=="power/control"''
        ''ATTR{power/control}="on"''
      ])

      # Keep USB power on for all USB devices when on AC power
      # This ensures mobile charging continues while laptop is plugged in
      # Note: AC0 is the power supply name on ASUS Vivobook Pro 15 M6500QF
      # Run: ls /sys/class/power_supply/ to find your AC adapter name
      (mkRule [
        ''ACTION=="add"''
        ''SUBSYSTEM=="usb"''
        ''TEST=="power/control"''
        ''TEST=="/sys/class/power_supply/AC0/online"''
        ''ATTR{power/control}="on"''
      ])

      # hibernate at low battery
      (mkRule [
        ''SUBSYSTEM=="power_supply"''
        ''KERNEL=="BAT0"''
        ''ATTR{status}=="Discharging"''
        ''ATTR{capacity}=="[0-5]"''
        ''RUN+="${pkgs.systemd}/bin/systemctl hibernate"''
      ])
      # battery status notification
      # as of now, when the rule fires, it doesn't reach graphical target unit
      # and hence fails, but not just that, it somehow prevents further
      # tasks, example: my keyring fails to unlock with greetd login
      # (mkRule [
      #   ''ACTION=="change"''
      #   ''SUBSYSTEM=="power_supply"''
      #   ''ATTRS{type}=="Mains"''
      #   ''ATTRS{online}=="0"''
      #   ''RUN+="${pkgs.systemd}/bin/systemd-run --machine=${targetMachine} --user ${pkgs.libnotify}/bin/notify-send -e -i battery -u low -h string:synchronous:battery_status 'Changing Power States' 'Using battery power'"''
      # ])
      # (mkRule [
      #   ''ACTION=="change"''
      #   ''SUBSYSTEM=="power_supply"''
      #   ''ATTRS{type}=="Mains"''
      #   ''ATTRS{online}=="1"''
      #   ''RUN+="${pkgs.systemd}/bin/systemd-run --machine=${targetMachine} --user ${pkgs.libnotify}/bin/notify-send -e -i battery_plugged -u low -h string:synchronous:battery_status 'Changing Power States' 'Using AC power'"''
      # ])
    ];
}
