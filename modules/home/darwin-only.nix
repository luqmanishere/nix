{
  imports = [
    # ./terminals/kitty.nix
    # ./tools/fonts.nix
    ./default.nix
  ];

  modules.terminals.kitty.fontSize = 12.0;

  warnings = [
    ''
      The module `darwin-only` is deprecated.
      Please use the `homeModules.default` module and enable the desired options.
    ''
  ];
}
