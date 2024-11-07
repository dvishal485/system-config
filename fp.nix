{ stdenv, lib, fetchurl, rpm, cpio, glib, gusb, pixman, libgudev, nss, libfprint, cairo, pkg-config, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "libfprint-focaltech-2808-a658";
  libso = "libfprint-2.so.2.0.0";
  version = "0.0.1";

  src = fetchurl {
    url = "https://github.com/ftfpteams/RTS5811-FT9366-fingerprint-linux-driver-with-VID-2808-and-PID-a658/raw/refs/heads/main/libfprint-2-2-1.94.4+tod1-FT9366_20240627.x86_64.rpm";
    hash = "sha256-MRWHwBievAfTfQqjs1WGKBnht9cIDj9aYiT3YJ0/CUM=";
  };

  nativeBuildInputs = [
    rpm cpio
    pkg-config
    autoPatchelfHook
  ];

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
    rpm2cpio $src | cpio -idmv
  '';

  installPhase = ''
    install -Dm444 usr/lib64/${libso} -t $out/lib

    # create this symlink as it was there in libfprint
    ln -s -T $out/lib/${libso} $out/lib/libfprint-2.so
    ln -s -T $out/lib/${libso} $out/lib/libfprint-2.so.2

    mkdir $out/lib/pkgconfig
    echo -e "prefix=$out\nincludedir=$out/include\nlibdir=$out/lib\n\nName: libfprint-2\nDescription: Generic C API for fingerprint reader access\nVersion: 1.94.6\nRequires: gio-unix-2.0 >= 2.56, gobject-2.0 >= 2.56\nLibs: -L$out/lib -lfprint-2 \nCflags: -I$out/include/libfprint-2\n" > $out/lib/pkgconfig/libfprint-2.pc

    # get files from libfprint required to build the package
    cp -r ${libfprint}/lib/girepository-1.0 $out/lib
    cp -r ${libfprint}/include $out
  '';
}
