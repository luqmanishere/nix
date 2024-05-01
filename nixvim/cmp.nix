_: {
  config = {
    plugins = {
      cmp = {
        enable = true;
        autoEnableSources = true;
        extraOptions = {
          # TODO: add neorg?
          sources = [];
          view.docs.auto_open = true;
        };
        settings = {
          # TODO: port over any mappings
          mapping = {
          };
        };
      };
      cmp-buffer.enable = true;
      cmp-dap.enable = true;
      cmp-fish.enable = true;
      cmp-git.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-nvim-lsp-document-symbol.enable = true;
      cmp-nvim-lsp-signature-help.enable = true;
      cmp-path.enable = true;
      cmp-treesitter.enable = true;
    };

    # configuring autopairs
    extraConfigLuaPost = ''
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done',
      cmp_autopairs.on_confirm_done())
    '';
  };
}
