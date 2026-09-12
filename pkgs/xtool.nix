{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
}: let
  pname = "xtool";
  version = "1.19.0";

  arch =
    if stdenv.hostPlatform.isAarch64
    then "aarch64"
    else "x86_64";

  hash = {
    aarch64 = "sha256-5L1/X4IrHuaalHP/jnHXdA3c4KPwJFlB0SptDbO3bgw=";
    x86_64 = "sha256-yxuqcfeS0VVIxOb4dwCmb5GIXx39TpwZwOpUFVWJydQ=";
  };

  src = fetchurl {
    url = "https://github.com/xtool-org/xtool/releases/download/${version}/xtool-${arch}.AppImage";
    hash = hash.${arch};
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -Dm444 ${appimageContents}/xtool.desktop \
        $out/share/applications/xtool.desktop
      install -Dm444 ${appimageContents}/xtool.png \
        $out/share/icons/hicolor/512x512/apps/xtool.png
    '';

    meta = {
      description = "Cross-platform Xcode replacement for building and deploying iOS apps with SwiftPM";
      homepage = "https://xtool.sh";
      changelog = "https://github.com/xtool-org/xtool/releases/tag/${version}";
      license = lib.licenses.mit;
      platforms = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      mainProgram = "xtool";
    };
  }
