{ config, pkg, lib, ... }: with lib; let
  cfg = config.hyprland;
in
{
  imports = [ ];

  options.hyprland = {
    enable = mkOption {
      default = false;
      description = "Enable hyprland configuration";
      type = types.bool;
    };
  };

  config = mkIf (cfg.enable) {
    home = {
      packages = with pkgs; [ ];
    };

    wayland.windowManager.hyprland.enable = true;
  };
}
