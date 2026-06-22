{...}: {
  perSystem = {pkgs, ...}: {
    packages = import ../../pkgs {inherit pkgs;};
  };

  flake.overlays.default = final: prev: import ../../pkgs {pkgs = final;};
}
