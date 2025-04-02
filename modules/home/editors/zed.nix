{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.editors.zed;
in {
  options.modules.editors.zed = {
    enable = mkEnableOption "Enable the zed editor";
  };

  config = mkIf cfg.enable {
    programs.zed-editor.enable = true;

    assertions = [
      {
        assertion = config.modules.core.gui.enable;
        message = "Requires a graphical environment";
      }
    ];
  };
}
