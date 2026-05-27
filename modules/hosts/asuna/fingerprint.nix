# README
# The fingerprint sensor for Honor Art 14 2025 is 1c7a:05aa LighTuning Technology Inc. Egistec-ETU906Axx
# This here is based on https://github.com/westi77/magic_book_pro_14_linux_guide/blob/main/Fingerprint-1c7a.md
# The fprint lib fork is based off https://github.com/TenSeventy7/libfprint-egismoc-sdcp and is patched
# to match the gist, including multiline edits all included in a single patch file. Additionally, we add the
# newly supported vendor ids to the autosuspend.hwdb file to pass udev-hwdb check.
#
# This patch was translated with AI, because I was too dumb to understand what the python code did,
# which was just a patch lmao.
#
# Anyways, it works. Will I maintain for changes? IDK, im patching a fork with already has an unmerged
# pr open for this.
{...}: {
  flake.modules.nixos.asuna-fingerprint = {pkgs, ...}: {
    nixpkgs.overlays = [
      (final: prev: {
        libfprint-egismoc-sdcp-1c7a-05aa = prev.libfprint.overrideAttrs (_old: {
          pname = "libfprint-egismoc-sdcp-1c7a-05aa";
          version = "1.94.9-4d128d4";

          src = final.fetchgit {
            url = "https://github.com/TenSeventy7/libfprint-egismoc-sdcp.git";
            rev = "4d128d4f6f0b46182572126e84df88a73ac27859";
            hash = "sha256-ij+g5iuWJqMNTDvqTTYWB9BD3Zi+1PzG075rcFULC4w=";
          };

          patches = [
            ./patches/libfprint-egismoc-sdcp-1c7a-05aa.patch
          ];
        });
      })
    ];

    services.fprintd = {
      enable = true;
      package = pkgs.fprintd.override {
        libfprint = pkgs.libfprint-egismoc-sdcp-1c7a-05aa;
      };
    };
  };
}
