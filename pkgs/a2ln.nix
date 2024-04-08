{
  stdenv,
  pkgs,
  lib,
  fetchFromGitHub,
  fetchPypi,
  buildPythonApplication,
  wrapGAppsNoGuiHook,
}:
with pkgs.python3Packages;
  buildPythonApplication rec {
    pname = "a2ln";
    version = "1.1.14";
    format = "pyproject";

    src = fetchFromGitHub {
      owner = "patri9ck";
      repo = "a2ln-server";
      rev = version;
      hash = "sha256-6SVAFeVB/YpddJhSHgjIF43i2BAmFFADMwlygp9IrSU=";
    };

    buildInputs = with pkgs; [
      libnotify
      gtk3
    ];
    nativeBuildInputs = [
      pkgs.gobject-introspection
      wrapGAppsNoGuiHook
    ];
    propagatedBuildInputs = with pkgs.python3Packages; [
      setuptools
      pillow
      setproctitle
      pyzmq
      qrcode
      pygobject3
    ];

    meta = {
      homepage = "https://github.com/patri9ck/a2ln-server/";
      description = "A way to display Android phone notifications on Linux (Server) ";
    };
  }
