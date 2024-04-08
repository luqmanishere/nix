{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.terminals.kitty;
in {
  imports = [];

  options.modules.terminals.kitty = {
    enable = mkOption {
      default = true;
      description = "Enable the great kitty terminal config";
      type = types.bool;
    };
  };

  config = mkIf (cfg.enable) {
    home = {
      packages = with pkgs; [
        kitty
      ];
    };

    programs.kitty = {
      enable = true;
      font = {
        name = "Iosevka SolemnAttic";
        size = 16.0;
      };
      theme = "Catppuccin-Mocha";
    };
  };
}
