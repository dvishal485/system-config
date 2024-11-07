{ stdenv, lib, fetchurl, dpkg, autoPatchelfHook, glib, gusb, pixman, libgudev, nss, tree, libfprint, cairo, pkg-config, coreutils }:

stdenv.mkDerivation rec {
  pname = "libfprint-ft9366";
  version = "1.94.4";

  src = fetchurl {
    url = "https://github.com/ftfpteams/RTS5811-FT9366-fingerprint-linux-driver-with-VID-2808-and-PID-a658/raw/b040ccd953c27e26c1285c456b4264e70b36bc3f/libfprint-2-2_1.94.4+tod1-0ubuntu1~22.04.2_amd64_rts5811.deb";
    hash = "sha256-vH1SbJ+/Uro7IQKM/SNUo44ySZqMwj+SgmmzOmwAgpw=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    pkg-config
  ];

  # LD_LIBRARY_PATH = lib.makeLibraryPath buildInputs;

  buildInputs = [
    stdenv.cc.cc
    glib
    gusb
    pixman
    nss
    libgudev
    libfprint
    cairo
  ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    cp -r . $out/

    # move out to correct dir
    mv $out/usr/lib/x86_64-linux-gnu/libfprint-2.so.2.0.0 $out/lib
    mv $out/usr/lib/x86_64-linux-gnu/libfprint-2.so.2 $out/lib

    # create this symlink as it was there in libfprint
    ln -s -T $out/lib/libfprint-2.so.2.0.0 $out/lib/libfprint-2.so

    # this .so was not marked executable by default
    chmod +x $out/lib/libfprint-2.so.2.0.0

    mkdir $out/lib/pkgconfig
    echo -e "prefix=$out\nincludedir=$out/include\nlibdir=$out/lib\n\nName: libfprint-2\nDescription: Generic C API for fingerprint reader access\nVersion: 1.94.6\nRequires: gio-unix-2.0 >= 2.56, gobject-2.0 >= 2.56\nLibs: -L$out/include -lfprint-2 \nCflags: -I$out/include/libfprint-2\n" > $out/lib/pkgconfig/libfprint-2.pc

    # get files from libfprint required to build the package
    cp -r ${libfprint}/lib/girepository-1.0 $out/lib
    cp -r ${libfprint}/include $out
  '';
}
