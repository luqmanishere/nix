{inputs, ...}: {
  imports = [inputs.flake-root.flakeModule inputs.treefmt-nix.flakeModule];
  perSystem = {
    inputs',
    config,
    pkgs,
    ...
  }: {
    treefmt = {
      inherit (config.flake-root) projectRootFile;

      package = pkgs.treefmt;

      programs = {
        alejandra.enable = true;
        alejandra.package = inputs'.alejandra.packages.default;
        prettier.enable = true;
        shfmt.enable = true;
        stylua.enable = true;
        # terraform.enable = true;
      };
    };
  };
}
