{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  wrapGAppsHook3,
  cargo-tauri,
  glib,
  gtk3,
  webkitgtk_4_1,
  gdk-pixbuf,
  cairo,
  pango,
  fontconfig,
  openssl,
  libsoup_3,
  glib-networking,
  gst_all_1,
  libGL,
  libxkbcommon,
  wayland,
  libsecret,
  libappindicator-gtk3,
  vulkan-loader,
}: let
  gstPluginPath = lib.makeSearchPath "lib/gstreamer-1.0" [
    cargo-tauri.gst-plugin
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
  ];
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "mudforge";
    version = "1.2.1865";

    src = fetchurl {
      url = "https://github.com/Coffee-Nerd/MudForge/releases/download/v${finalAttrs.version}/MudForge_${finalAttrs.version}_amd64.deb";
      hash = "";
    };

    unpackCmd = "dpkg -x $curSrc source";

    nativeBuildInputs = [
      dpkg
      autoPatchelfHook
      wrapGAppsHook3
    ];

    buildInputs = [
      glib
      gtk3
      webkitgtk_4_1
      gdk-pixbuf
      cairo
      pango
      fontconfig
      openssl
      libsoup_3
      glib-networking
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-libav
      libGL
      libxkbcommon
      wayland
      libsecret
      libappindicator-gtk3
      vulkan-loader
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r usr/* $out/

      runHook postInstall
    '';

    preFixup = ''
      gappsWrapperArgs+=(
        --prefix WEBKIT_GST_ALLOWED_URI_PROTOCOLS : "asset"
        --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${gstPluginPath}"
      )
    '';

    meta = {
      description = "Modern, cross-platform MUD client";
      homepage = "https://github.com/Coffee-Nerd/MudForge";
      license = lib.licenses.mit;
      platforms = ["x86_64-linux"];
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      mainProgram = "mudforge";
    };
  })
