{ pkgs, pkgs-unstable, ... }:
let
  androidComposition = pkgs-unstable.androidenv.composeAndroidPackages {
    cmdLineToolsVersion = "19.0";
    platformToolsVersion = "36.0.0";
    toolsVersion = "26.1.1";
    buildToolsVersions = [
      "36.0.0"
      "35.0.0"
    ];
    platformVersions = [
      "36"
      "35"
    ];
    includeEmulator = true;
    includeSystemImages = true;
    systemImageTypes = [ "google_apis" ];
    abiVersions = [ "x86_64" ];
  };

  androidSdk = pkgs.symlinkJoin {
    name = "androidsdk-with-cmdline-tools-latest";
    paths = [ androidComposition.androidsdk ];
    postBuild = ''
      sdkRoot="$out/libexec/android-sdk"
      if [ -d "$sdkRoot/cmdline-tools/19.0" ] && [ ! -e "$sdkRoot/cmdline-tools/latest" ]; then
        ln -s "$sdkRoot/cmdline-tools/19.0" "$sdkRoot/cmdline-tools/latest"
      fi
    '';
  };
  androidSdkPath = "${androidSdk}/libexec/android-sdk";
in
{
  home.packages = with pkgs; [
    flutter
    pkgs-unstable.android-studio
    jdk17
    gradle
    androidSdk
  ];

  home.sessionVariables = {
    ANDROID_HOME = androidSdkPath;
    ANDROID_SDK_ROOT = androidSdkPath;
    JAVA_HOME = "${pkgs.jdk17}/lib/openjdk";
  };

  home.sessionPath = [
    "${androidSdkPath}/platform-tools"
    "${androidSdkPath}/emulator"
    "${androidSdkPath}/cmdline-tools/latest/bin"
  ];
}
