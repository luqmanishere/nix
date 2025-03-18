{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.games.general;
in {
  options.modules.games.general = {
    enable = lib.mkEnableOption "enable games";
  };
  config = lib.mkIf cfg.enable {
    # TODO: split these up
    home.packages = with pkgs; [
      prismlauncher
      gamescope
      mangohud
      scrcpy
      (discord.override {withVencord = true;})
    ];

    assertions = [
      {
        assertion = config.modules.core.gui.enable;
        message = "a desktop environment is required";
      }
    ];
  };
}
