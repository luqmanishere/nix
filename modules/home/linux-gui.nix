{
  imports = [
    ./default.nix
  ];

  warnings = [
    ''
      The module `linux-gui` is deprecated.
      Please use the `homeModules.default` module and enable the desired options.
    ''
  ];
}
