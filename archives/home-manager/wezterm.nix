{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.wezterm-conf;
in {
  imports = [];

  options.wezterm-conf = {
    enable = mkOption {
      default = false;
      description = "Enable the great kitty terminal config";
      type = types.bool;
    };
  };

  config = mkIf (cfg.enable) {
    home = {
      packages = with pkgs; [
        wezterm
      ];
    };

    programs.wezterm = {
      enable = true;
      extraConfig = builtins.readFile ./wezterm/wezterm.lua;
    };
  };
}
