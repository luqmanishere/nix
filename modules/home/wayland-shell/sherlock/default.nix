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
  # imports = [sherlock.homeManagerModules.default];

  options.modules.wayland-shell.sherlock.enable = mkEnableOption "Enable sherlock";

  config = mkIf cfg.enable {
    programs.sherlock = {
      enable = true;
      settings = null;
    };
  };
}
