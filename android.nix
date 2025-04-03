{
  pkgs,
  ...
}:
let
  versions = {
    cmdLineTools = "13.0";
    tools = "26.1.1";
    platformTools = "35.0.2";
    buildTools = "34.0.0";
    emulator = "35.2.5";
    platform = "34";
    cmake = "3.22.1";
    ndk = "27.0.12077973";
  };
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    includeSources = false;
    includeSystemImages = false;
    buildToolsVersions = [
      versions.buildTools
      "33.0.1"
      "30.0.3"
    ];
    platformVersions = [
      versions.platform
      "33"
      "32"
    ];
    abiVersions = [ "x86_64" ];
    cmdLineToolsVersion = versions.cmdLineTools;
    toolsVersion = versions.tools;
    platformToolsVersion = versions.platformTools;
    includeEmulator = false;
    emulatorVersion = versions.emulator;
    systemImageTypes = [ "google_apis" ];
    cmakeVersions = [ versions.cmake ];
    includeNDK = true;
    ndkVersion = versions.ndk;
    ndkVersions = [ versions.ndk ];
    useGoogleAPIs = true;
    useGoogleTVAddOns = false;
    # includeExtras = [ ];
    # extraLicenses = [ ];
  };
  androidSdk = androidComposition.androidsdk;
in
{
  nixpkgs.config.android_sdk.accept_license = true;
  environment.systemPackages = [
    (pkgs.android-studio-full.withSdk androidSdk)
  ];
}
