{ inputs, outputs, config, pkg, lib, ... }: with lib; let
  cfg = config.hyprland;
in
{
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

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

    wayland.windowManager.hyprland = {
      enable = true;
      systemdIntegration = true;
      recommendedEnvironment = true;
      extraConfig = null;
    };
  };
}
