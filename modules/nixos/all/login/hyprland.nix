{
  flake,
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  inherit (flake) inputs;
  cfg = config.modules.wm.hyprland;
in {
  options.modules.wm.hyprland.enable = mkEnableOption "Enable Hyprland";

  config = (mkIf cfg.enable) {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    };
  };
}
