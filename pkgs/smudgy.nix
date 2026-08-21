{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchurl,
  pkg-config,
  openssl,
  wayland,
  dbus,
  libxkbcommon,
  libGL,
  vulkan-loader,
  makeWrapper,
}:
let
  version = "0.5.5-rc";

  # The `v8` crate (via deno_core/deno_runtime) normally downloads a prebuilt
  # librusty_v8 archive from GitHub at build time, which fails in the sandbox.
  # Prefetch it instead and point the build at it (RUSTY_V8_ARCHIVE +
  # RUSTY_V8_SRC_BINDING_PATH; never V8_FROM_SOURCE — see the project's
  # packaging/linux/README.md). deno_core 0.410 enables the v8 `simdutf`
  # feature, so the simdutf-flavored assets for the locked v8 crate version
  # (150.4.0, via deno_core 0.410 -> deno_v8 0.2) are required. x86_64-linux only.
  librustyV8Archive = fetchurl {
    url = "https://github.com/denoland/rusty_v8/releases/download/v150.4.0/librusty_v8_simdutf_release_x86_64-unknown-linux-gnu.a.gz";
    hash = "sha256-9IdiyhDR8fxgWkQcWuQw7Izh6egPFNePvELLh4wwtHY=";
  };
  librustyV8Binding = fetchurl {
    url = "https://github.com/denoland/rusty_v8/releases/download/v150.4.0/src_binding_simdutf_release_x86_64-unknown-linux-gnu.rs";
    hash = "sha256-dyeCauR5vbZF6Acjn7EtH44uI956bPFvXuWSaQ0dhQY=";
  };

  # The workspace's [patch.crates-io] path overrides. Cargo.lock records these
  # as PATH deps (no `source`), so importCargoLock skips them — fetch the
  # pristine crates.io tarballs here and materialize target/patch from them.
  patchedCrates = {
    "iced_graphics-0.14.0" = fetchurl {
      url = "https://static.crates.io/crates/iced_graphics/iced_graphics-0.14.0.crate";
      hash = "sha256-I0yhws7EFVBV9o+l+tG1JCxJasgjjYCiWbyjgvtEoQI=";
    };
    "cosmic-text-0.15.0" = fetchurl {
      url = "https://static.crates.io/crates/cosmic-text/cosmic-text-0.15.0.crate";
      hash = "sha256-FzhSKDqaV6PL42XYbnTcQooJxQQhR31a1v6dlQnjdzc=";
    };
    "vtparse-0.7.0" = fetchurl {
      url = "https://static.crates.io/crates/vtparse/vtparse-0.7.0.crate";
      hash = "sha256-Fya12rzxiQkhmhHBrjuF//kxtuXM9zIdmY/HZl9SZhs=";
    };
    "deno_permissions-0.116.0" = fetchurl {
      url = "https://static.crates.io/crates/deno_permissions/deno_permissions-0.116.0.crate";
      hash = "sha256-df2WD2ljndv4DOC84wlGcpW7U6P7lEPrBum5I1JeCDY=";
    };
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "smudgy";
  inherit version;

  src = fetchFromGitHub {
    owner = "smudgy-mud";
    repo = "smudgy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-V3f4Df+YiY6Uybgc74hL6r4RTpR9+X3YclWBxTBXAYE=";
  };

  # All deps come from the lockfile (no cargo vendor pass, so the
  # [patch.crates-io] path overrides below don't need to exist yet).
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = "${finalAttrs.src}/Cargo.lock";
  };

  nativeBuildInputs = [
    pkg-config
    # libsqlite3-sys (via deno_runtime -> rusqlite) builds with buildtime_bindgen
    rustPlatform.bindgenHook
    makeWrapper
  ];

  buildInputs = [
    openssl # reqwest default-tls (native-tls)
    wayland # winit (wayland-backend client_system links libwayland-client)
    dbus # libdbus-sys via dbus-secret-service (keyring) and tao (iced windowing)
  ];

  env = {
    RUSTY_V8_ARCHIVE = librustyV8Archive;
    RUSTY_V8_SRC_BINDING_PATH = librustyV8Binding;
  };

  # smudgy_ui's test harness doesn't compile against the patched renderer
  # (iced_renderer fallback + Widget::layout bound mismatch); upstream's
  # release build (flatpak) never builds tests either.
  doCheck = false;

  postPatch = ''
    # Materialize the patch-crate managed dependency patches (patches/*.patch →
    # target/patch/) that the workspace's [patch.crates-io] entries point at.
    # Upstream runs `cargo patch-crate` on a fresh checkout; here we unpack the
    # pristine crates.io tarballs and apply the patches to them.
    mkdir -p target/patch
    declare -A patch_src=(
      [iced_graphics-0.14.0]='${patchedCrates."iced_graphics-0.14.0"}'
      [cosmic-text-0.15.0]='${patchedCrates."cosmic-text-0.15.0"}'
      [vtparse-0.7.0]='${patchedCrates."vtparse-0.7.0"}'
      [deno_permissions-0.116.0]='${patchedCrates."deno_permissions-0.116.0"}'
    )
    for spec in iced_graphics+0.14.0 cosmic-text+0.15.0 vtparse+0.7.0 deno_permissions+0.116.0; do
      crate=''${spec%%+*}
      ver=''${spec##*+}
      dir="target/patch/$crate-$ver"
      mkdir -p "$dir"
      tar xf "''${patch_src[$crate-$ver]}" -C "$dir" --strip-components=1
      chmod -R u+w "$dir"
      patch -d "$dir" -p1 < "patches/$crate+$ver.patch"
    done
  '';

  postInstall = ''
    # Desktop integration, taken from the project's flatpak packaging.
    install -Dm644 packaging/linux/org.smudgy.Smudgy.desktop -t $out/share/applications/
    install -Dm644 packaging/linux/org.smudgy.Smudgy.metainfo.xml -t $out/share/metainfo/
    install -Dm644 packaging/linux/org.smudgy.Smudgy.png $out/share/icons/hicolor/256x256/apps/org.smudgy.Smudgy.png
    install -Dm644 packaging/linux/org.smudgy.Smudgy-512.png $out/share/icons/hicolor/512x512/apps/org.smudgy.Smudgy.png
    # dlopen'd at runtime (winit wayland/xkbcommon, wgpu EGL/Vulkan), not
    # linked — RPATH won't cover them, so add them explicitly.
    wrapProgram $out/bin/smudgy \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [wayland libxkbcommon libGL vulkan-loader]}
  '';

  meta = {
    description = "Modern graphical MUD client with scripting, triggers, aliases and automapping";
    homepage = "https://github.com/smudgy-mud/smudgy";
    license = lib.licenses.gpl3Only;
    mainProgram = "smudgy";
    platforms = lib.platforms.x86_64;
  };
})
