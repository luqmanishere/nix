{self, ...}: {
  perSystem = {
    inputs',
    pkgs,
    ...
  }: let
    inherit (inputs') nixvim;
    nixvimLib = nixvim.lib;
    nixvim' = nixvim.legacyPackages;
    nixvimModule = {
      inherit pkgs;
      module = ./modules.nix;

      # TODO: use nightly for now
      extraSpecialArgs = {
        nvim-package = inputs'.neovim-nightly-overlay.packages.neovim;
        flake-inputs = inputs';
      };
    };
    nvim = nixvim'.makeNixvimWithModule nixvimModule;
  in {
    packages.nvim = nvim;
    checks.nvim = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
    packages.default = nvim;
  };
}
