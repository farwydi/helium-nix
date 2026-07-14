{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
}:

let
  sources = builtins.fromJSON (builtins.readFile ./sources.json);
  system = stdenv.hostPlatform.system;
  entry = sources.systems.${system} or (throw "helium: unsupported system ${system}");

  pname = "helium";
  version = sources.version;

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-${entry.target}.AppImage";
    hash = entry.hash;
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/helium.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share/
  '';

  meta = {
    description = "Private, fast, and honest web browser (Chromium-based)";
    homepage = "https://github.com/imputnet/helium";
    license = lib.licenses.gpl3Only;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "helium";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
