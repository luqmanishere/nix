{...}: {
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        git
        helix
        home-manager
        nh
        wget
      ];
    };
  };
}
