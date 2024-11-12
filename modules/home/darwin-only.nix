{
  imports = [
    ./all/terminals/kitty.nix
    ./all/tools/fonts.nix
  ];

  modules.terminals.kitty.fontSize = 12.0;
}
