{
  lib,
  appimageTools,
  fetchurl,
  mesa,
  libglvnd,
  vulkan-loader,
  wayland,
  libxkbcommon,
  webkitgtk_4_1,
  gtk3,
  glib,
  gdk-pixbuf,
  glib-networking,
  librsvg,
  json-glib,
  libsoup_3,
  gst_all_1,
  cargo-tauri,
  cacert,
}: let
  pname = "mudforge-appimage";
  version = "1.2.1876";
  gstPluginPath = lib.makeSearchPath "lib/gstreamer-1.0" [
    cargo-tauri.gst-plugin
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
  ];

  src = fetchurl {
    url = "https://github.com/Coffee-Nerd/MudForge/releases/download/v${version}/MudForge_${version}_amd64.AppImage";
    hash = "sha256-c8DYh3BGq1Gfv5tWIVhESu3pVRISSsYI4h7/kdPcBJg=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;

    postExtract = ''
      find "$out/usr/lib" -type f -name '*.so*' -print -delete
      sed -i \
        -e 's|^export GDK_PIXBUF_MODULE_FILE=.*|export GDK_PIXBUF_MODULE_FILE="${librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"|' \
        -e 's|^export GIO_EXTRA_MODULES=.*|export GIO_EXTRA_MODULES="${glib-networking}/lib/gio/modules"|' \
        "$out/apprun-hooks/linuxdeploy-plugin-gtk.sh"
    '';
  };
in
  appimageTools.wrapAppImage {
    inherit pname version;

    src = appimageContents;

    extraPkgs = pkgs:
      (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs)
      ++ [
        mesa
        libglvnd
        vulkan-loader
        wayland
        libxkbcommon
        webkitgtk_4_1
        gtk3
        glib
        gdk-pixbuf
        glib-networking
        librsvg
        json-glib
        libsoup_3
        cacert
        cargo-tauri.gst-plugin
        gst_all_1.gstreamer
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-plugins-ugly
        gst_all_1.gst-libav
      ];

    profile = ''
      export GIO_MODULE_DIR="${glib-networking}/lib/gio/modules"
      export GIO_EXTRA_MODULES="${glib-networking}/lib/gio/modules"
      export GDK_PIXBUF_MODULE_FILE="${librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"
      export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
      export WEBKIT_GST_ALLOWED_URI_PROTOCOLS="asset"
      export GST_PLUGIN_SYSTEM_PATH_1_0="${gstPluginPath}:/usr/lib64/gstreamer-1.0:/usr/lib/gstreamer-1.0"
      export GST_PLUGIN_PATH_1_0="$GST_PLUGIN_SYSTEM_PATH_1_0"
      export GST_PLUGIN_PATH="$GST_PLUGIN_SYSTEM_PATH_1_0"
      export GST_PLUGIN_SCANNER_1_0="${gst_all_1.gstreamer}/libexec/gstreamer-1.0/gst-plugin-scanner"
      export GST_PLUGIN_SCANNER="$GST_PLUGIN_SCANNER_1_0"
    '';

    passthru.src = src;

    meta = {
      description = "Modern, cross-platform MUD client";
      homepage = "https://github.com/Coffee-Nerd/MudForge";
      license = lib.licenses.mit;
      platforms = ["x86_64-linux"];
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      mainProgram = "mudforge-appimage";
    };
  }
