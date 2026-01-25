{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.tools.pidgin;
in {
  options.modules.tools.pidgin = {enable = mkEnableOption "Enable the pidgin messenger app";};

  config = mkIf cfg.enable {
    programs.pidgin = {
      enable = true;
      plugins = [];
    };

    assertions = [
      {
        assertion = config.modules.core.gui.enable;
        message = "a graphical environment is required";
      }
    ];
  };
}
