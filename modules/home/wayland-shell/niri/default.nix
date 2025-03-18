{
  flake,
  config,
  lib,
  ...
}:
with lib; let
  inherit (flake) inputs;
  inherit (inputs) niri-flake;
  cfg = config.modules.wayland-shell.niri;
in {
  # this is not needed because the flake auto imports in the nixos module
  # imports = [niri-flake.homeModules.niri];

  options.modules.wayland-shell.niri = {
    enable = mkEnableOption "Enable niri, the scrolling wayland window manager";
  };

  config = mkIf cfg.enable {
    modules.core.gui.enable = mkForce true;
    modules.wayland-shell.utils.enable = mkForce true;

    programs.niri = {
      # enable = true;
      config = readFile ./config.kdl;
    };
  };
}
