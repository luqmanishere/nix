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
    version = "1.1.10";
    format = "pyproject";

    src = fetchFromGitHub {
      owner = "patri9ck";
      repo = "a2ln-server";
      rev = version;
      hash = "sha256-tMTCc9ngSCbDwjzTVCQ9Km8onp/t1hvn3pj5PO+1/Hc=";
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
      homepage = "https://github.com/pytoolz/toolz/";
      description = "List processing tools and functional utilities";
    };
  }
