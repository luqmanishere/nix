{
  config,
  lib,
  ...
}: let
  cfg = config.modules.solemnattic.tools.syncthing;
in {
  options.modules.solemnattic.tools.syncthing = {
    enableTray = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    guiPort = lib.mkOption {
      type = lib.types.int;
      default = 8384;
    };
  };

  config = {
    services.syncthing.enable = true;
    services.syncthing.guiAddress = "127.0.0.1:${toString cfg.guiPort}";
    services.syncthing.tray.enable = cfg.enableTray;
  };
}
