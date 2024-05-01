{nvim-package, ...}: {
  imports = [
    ./ui.nix

    ./lsp.nix
    ./none-ls.nix
    ./rust.nix

    ./treesitter.nix

    ./cmp.nix
    ./comment.nix

    ./mappings.nix
  ];
  config = {
    package = nvim-package;
    wrapRc = true;
    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };
  };
}
