{ ... }:
{
  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # set true for local time in hardware clock
  # for windows compatibility (UTC otherwise)
  time.hardwareClockInLocalTime = false;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "en_IN/UTF-8"
  ];

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN.utf-8";
    LC_IDENTIFICATION = "en_IN.utf-8";
    LC_MEASUREMENT = "en_IN.utf-8";
    LC_MONETARY = "en_IN.utf-8";
    LC_NAME = "en_IN.utf-8";
    LC_NUMERIC = "en_IN.utf-8";
    LC_PAPER = "en_IN.utf-8";
    LC_TELEPHONE = "en_IN.utf-8";
    LC_TIME = "en_IN.utf-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
}
