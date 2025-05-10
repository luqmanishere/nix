{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.tools.obsidian;
in {
  options.modules.tools.obsidian = {enable = mkEnableOption "Enable obsidian";};

  config = mkIf cfg.enable {
    home.packages = with pkgs; [obsidian];
  };
}
