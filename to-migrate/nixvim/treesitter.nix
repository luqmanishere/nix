_: {
  config = {
    plugins.treesitter = {
      enable = true;
      ensureInstalled = "all";
      folding = true;
      indent = true;
      nixvimInjections = true;
    };
    plugins.treesitter-context.enable = true;
    # do not autofold on start
    options.foldenable = false;
    # TODO: maybe fold some lines with use of foldlevel
  };
}
