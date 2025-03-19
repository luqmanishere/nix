{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.wayland-shell.utils;
in {
  options.modules.wayland-shell.utils = {
    enable = mkEnableOption "Enable wayland utilities";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      cliphist
      wl-clipboard
      wlr-randr
      pavucontrol
      brightnessctl
    ];
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 22;
    };

    assertions = [
      {
        assertion = config.modules.core.gui.enable;
        message = "a graphical wayland session is required.";
      }
    ];
  };
}
