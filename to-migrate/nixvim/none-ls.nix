_: {
  config = {
    plugins.none-ls = {
      enable = true;
      enableLspFormat = true;
      sources = {
        formatting = {
          alejandra.enable = true;
          stylua.enable = true;
        };
      };
    };
    plugins.lsp-format.enable = true;
  };
}
