{
  imports = [
    # ./tools/syncthing.nix
    ./default.nix
  ];

  modules.solemnattic.tools.syncthing.guiPort = 8300;
  warnings = [
    ''
      The module `linux-wsl` is deprecated.
      Please use the `homeModules.default` module and enable the desired options.
    ''
  ];
}
