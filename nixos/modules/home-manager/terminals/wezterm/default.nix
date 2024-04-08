{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.terminals.wezterm;
in {
  imports = [];

  options.modules.terminals.wezterm = {
    enable = mkOption {
      default = true;
      description = "Enable the fast wezterm terminal config";
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
      extraConfig = builtins.readFile ./wezterm.lua;
    };
  };
}
