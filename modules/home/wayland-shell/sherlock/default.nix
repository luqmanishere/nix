{
  flake,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  inherit (flake) inputs;
  inherit (inputs) sherlock;
  cfg = config.modules.wayland-shell.sherlock;
in {
  options.modules.wayland-shell.sherlock.enable = mkEnableOption "Enable sherlock";
  config = mkIf cfg.enable {
    # TODO: configuration

    home.packages = with pkgs; [
      sherlock-launcher
    ];
  };
}
