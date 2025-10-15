{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.editors.cursor;
in {
  options.modules.editors.cursor = {
    enable = mkEnableOption "Enable the Cursor editor";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [code-cursor nodejs];

    assertions = [
      {
        assertion = config.modules.core.gui.enable;
        message = "Requires a graphical environment";
      }
    ];
  };
}
