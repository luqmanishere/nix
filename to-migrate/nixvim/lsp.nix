_: {
  config = {
    plugins = {
      lsp = {
        enable = true;
        servers = {
          # TODO: configure more servers
          nil_ls = {enable = true;};
          # rust-analyzer = {
          #   enable = true;
          #   installCargo = false;
          #   installRustc = false;
          # };
        };
      };
    };
  };
}
