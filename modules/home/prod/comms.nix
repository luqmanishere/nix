{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.productivity.comms;
in {
  options.modules.productivity.comms = {
    enable = lib.mkEnableOption "Enable graphical communication apps";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      tdesktop
      whatsapp-for-linux
    ];

    assertions = [
      {
        assertion = config.modules.core.gui.enable;
        message = "A desktop environment is required.";
      }
    ];
  };
}
