{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.games.lutris;
in {
  options.modules.games.lutris = {enable = lib.mkEnableOption "Enable Lutris launcher";};

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      lutris
      protonup-qt
      zstd
    ];

    assertions = [
      {
        assertion = config.modules.core.gui.enable;
        message = "a desktop environment is required";
      }
    ];
  };
}
