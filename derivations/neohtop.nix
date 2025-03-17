{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  glib,
  gtk3,
  cairo,
  gdk-pixbuf,
  libsoup_3,
  webkitgtk_4_1,
}:

let
  version = "1.1.2";
  architecture = "x86_64";
in
stdenv.mkDerivation {
  pname = "NeoHtop";
  inherit version;
  src = fetchurl {
    url = "https://github.com/Abdenasser/neohtop/releases/download/v${version}/NeoHtop_${version}_${architecture}.deb";
    hash = "sha256-06niCR/X6Lshp0Yw8VqVHUTTV+RMN/ytS+mAxrlNets=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    stdenv.cc.cc
    glib
    gtk3
    cairo
    gdk-pixbuf
    libsoup_3
    webkitgtk_4_1
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x $src $out
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mv $out/*/* $out
    runHook postInstall
  '';

  meta = {
    description = "A modern, cross-platform system monitor built on top of Svelte, Rust, and Tauri.";
    homepage = "https://abdenasser.github.io/neohtop/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.imsick ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
