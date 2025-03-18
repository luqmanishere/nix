# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'
{pkgs, ...}: {
  # example = pkgs.callPackage ./example { };
  a2ln = pkgs.callPackage ./a2ln.nix {inherit (pkgs.python3Packages) buildPythonApplication;};
  iosevka-solemnattic = pkgs.callPackage ./iosevka.nix {
    privateBuildPlan = ''
      [buildPlans.IosevkaSolemnAttic]
      family = "Iosevka SolemnAttic"
      spacing = "fontconfig-mono"
      serifs = "sans"
      noCvSs = true
      exportGlyphNames = true
    '';
    set = "SolemnAttic";
  };
  maple-mono-NF-beta = (pkgs.callPackage ./maple-mono.nix {}).NF;
  siyuan-unlock = pkgs.callPackage ./siyuan/package.nix {};
}
