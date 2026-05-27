{inputs, ...}: {
  imports = [inputs.flake-root.flakeModule inputs.treefmt-nix.flakeModule];
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    treefmt = {
      inherit (config.flake-root) projectRootFile;

      package = pkgs.treefmt;

      programs = {
        alejandra.enable = true;
        prettier.enable = true;
        shfmt.enable = true;
        stylua.enable = true;
        # terraform.enable = true;
      };
    };
  };
}
