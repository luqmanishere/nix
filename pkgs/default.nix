{pkgs, ...}: {
  iloader = pkgs.callPackage ./iloader.nix {};
  mudforge = pkgs.callPackage ./mudforge.nix {};
  mudforge-appimage = pkgs.callPackage ./mudforge-appimage.nix {};
  mudlet-custom = pkgs.callPackage ./mudlet.nix {};
  rune-mud = pkgs.callPackage ./rune.nix {};
}
