{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
  ripgrep,
  fd,
}:
let
  version = "0.85.1";
  platform = {
    "aarch64-darwin" = {
      archive = "pi-darwin-arm64.tar.gz";
      hash = "sha256-1fcOPAz3OY6sI5/QJh7gdNmLe6f2tD/jYX8FLtW3nQY=";
    };
    "aarch64-linux" = {
      archive = "pi-linux-arm64.tar.gz";
      hash = "sha256-BC0grohe5POxAoFfMoC5YsN3sun7RN5AN5CMxTDq5NQ=";
    };
    "x86_64-darwin" = {
      archive = "pi-darwin-x64.tar.gz";
      hash = "sha256-rbkYuEViXxhNi+pAjVXqyvIaqHI4eTwPW087lze85is=";
    };
    "x86_64-linux" = {
      archive = "pi-linux-x64.tar.gz";
      hash = "sha256-SU5Jj0fXTSH0CzOG9qXpIaPUlTGhacq1W72soOof4lo=";
    };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported Pi platform: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "pi-coding-agent";
  inherit version;

  src = fetchurl {
    url = "https://github.com/earendil-works/pi/releases/download/v${version}/${platform.archive}";
    inherit (platform) hash;
  };

  sourceRoot = "pi";

  nativeBuildInputs = [ makeWrapper ] ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;
  buildInputs = lib.optional stdenv.hostPlatform.isLinux stdenv.cc.cc.lib;

  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/libexec/pi" "$out/bin"
    cp -R . "$out/libexec/pi/"
    makeWrapper "$out/libexec/pi/pi" "$out/bin/pi" \
      --prefix PATH : ${lib.makeBinPath [ fd ripgrep ]}

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    HOME="$TMPDIR" "$out/bin/pi" --version
    runHook postInstallCheck
  '';

  meta = {
    description = "Coding agent CLI with read, bash, edit, write tools and session management";
    homepage = "https://pi.dev/";
    changelog = "https://github.com/earendil-works/pi/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "pi";
    platforms = builtins.attrNames {
      "aarch64-darwin" = null;
      "aarch64-linux" = null;
      "x86_64-darwin" = null;
      "x86_64-linux" = null;
    };
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
