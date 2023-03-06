{ inputs, pkgs, lib, config, ... }:
with lib; let
  cfg = config.rofi;
in
{
  imports = [ ];

  options.rofi = {
    enable = mkOption {
      default = false;
      description = "Enable rofi configuration";
      type = types.bool;
    };
  };

  config = mkIf (cfg.enable) {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      terminal = "\${pkgs.kitty}/bin/kitty";
    };
  };
}
