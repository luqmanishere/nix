{pkgs, ...}: {
  iloader = pkgs.callPackage ./iloader.nix {};
  mudforge = pkgs.callPackage ./mudforge.nix {};
  mudlet = pkgs.callPackage ./mudlet.nix {};
}
