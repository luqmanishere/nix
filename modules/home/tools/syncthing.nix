{
  config,
  lib,
  ...
}: let
  cfg = config.modules.solemnattic.tools.syncthing;
in {
  options.modules.solemnattic.tools.syncthing = {
    enable = lib.mkEnableOption "Enable syncthing service via home manager";
    enableTray = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    guiPort = lib.mkOption {
      type = lib.types.int;
      default = 8384;
    };
  };

  config = lib.mkMerge [
    {
      services.syncthing.enable = cfg.enable;
      services.syncthing.guiAddress = "127.0.0.1:${toString cfg.guiPort}";
      services.syncthing.tray.enable = cfg.enableTray;
    }
    (lib.mkIf cfg.enableTray {
      assertions = [
        {
          assertion = config.modules.core.gui.enable;
          message = "a graphical environment is required";
        }
      ];
    })
  ];
}
