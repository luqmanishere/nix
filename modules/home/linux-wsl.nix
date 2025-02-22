{
  imports = [
    ./all/tools/syncthing.nix
  ];

  modules.solemnattic.tools.syncthing.guiPort = 8300;
}
