{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  inherit (flake) inputs;
  cfg = config.modules.wayland-shell.quickshell;
in {
  imports = [];

  options.modules.wayland-shell.quickshell = {
    enable = mkOption {
      description = "wayper, a wallpaper setter for wayland";
      default = false;
      type = types.bool;
    };
  };

  # config = mkIf cfg.enable {
  config = {
    home.packages = [
      inputs.quickshell.packages.${pkgs.system}.default
      pkgs.kdePackages.qtdeclarative
    ];
    qt.enable = true;
  };
}
