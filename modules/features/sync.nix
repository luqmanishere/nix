{...}: {
  flake.modules.homeManager.sync = {
    services.syncthing.enable = true;
    services.syncthing.guiAddress = "127.0.0.1:8384";
    services.syncthing.tray.enable = true;
  };
}
