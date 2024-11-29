{ pkgs, lib, ... }:
{
  # Power savings
  powerManagement.enable = true;
  services.thermald.enable = true;

  # disable ppd to enable tlp
  services.power-profiles-daemon.enable = lib.mkForce false;
  # tlp configurations: https://linrunner.de/tlp/settings/introduction.html
  services.tlp = {
    enable = true;
    settings = {
      # disbale wifi power savings
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
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      # AMD Turbo core
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      # Optional helps save long term battery health
      # START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 60; # 60 and above it stops charging
    };
  };

  # https://wiki.nixos.org/wiki/Power_Management
  services.udev.extraRules =
    let
      mkRule = as: lib.concatStringsSep ", " as;
      mkRules = rs: lib.concatStringsSep "\n" rs;
    in
    mkRules ([
      (mkRule [
        ''ACTION=="add|change"''
        ''SUBSYSTEM=="block"''
        ''KERNEL=="sd[a-z]"''
        ''ATTR{queue/rotational}=="1"''
        ''RUN+="${pkgs.hdparm}/bin/hdparm -B 90 -S 41 /dev/%k"''
      ])
    ]);
}
