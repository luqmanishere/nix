{
  imports = [
    ./default.nix
  ];

  warnings = [
    ''
      The module `linux-gui` is deprecated.
      Please use the `homeModules.common` module and enable the desired options.
    ''
  ];
}
