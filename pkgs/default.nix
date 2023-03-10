# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { } }: {
  # example = pkgs.callPackage ./example { };
  a2ln = pkgs.callPackage ./a2ln.nix { buildPythonApplication = pkgs.python3Packages.buildPythonApplication; };
}
