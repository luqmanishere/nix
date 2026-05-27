{
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
        prettier.enable = true;
        shfmt.enable = true;
        stylua.enable = true;
        # terraform.enable = true;
      };
    };
  };
}
