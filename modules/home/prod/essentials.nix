{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.productivity.essentials;
in {
  options.modules.productivity.essentials = {
    enable = lib.mkEnableOption "Enable essential graphical programs";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      obsidian
      zathura
    ];

    assertions = [
      {
        assertion = config.modules.core.gui.enable;
        message = "A graphical environment is required.";
      }
    ];
  };
}
