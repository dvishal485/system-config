{ pkgs, config, ... }:
let
  yamlFormat = pkgs.formats.yaml { };
in
{
  xdg.configFile."stirling-pdf/configs/custom_settings.yml" = {
    source = yamlFormat.generate "stirling-pdf-config" {
      system = {
        tessdataDir = "${pkgs.tesseract}/share/tessdata";
      };
    };
  };

  home.packages = with pkgs; [
    (pkgs.symlinkJoin {
      name = "document-tools";
      paths = with pkgs; [
        (pkgs.writeScriptBin "stirling-pdf" ''
          #!/usr/bin/env sh
          mkdir -p ${config.xdg.configHome}/stirling-pdf
          (cd ${config.xdg.configHome}/stirling-pdf && exec ${lib.getExe stirling-pdf} "$@")
        '')
        ocrmypdf
        tesseract
        unoconv
        libreoffice
        ghostscript_headless
        python313Packages.weasyprint
        poppler-utils
        kdePackages.okular
        onlyoffice-bin
      ];
    })
  ];
}
