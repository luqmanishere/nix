{
  flake,
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  inherit (flake) inputs;
  inherit (inputs) hyprlock;
  cfg = config.modules.wayland-shell.hyprlock;
in {
  options.modules.wayland-shell.hyprlock = {
    enable = mkEnableOption "Enable hyprlock, Hyprland's lock screen";
  };

  config = mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      package = hyprlock.packages.${pkgs.system}.hyprlock;
      settings = {
        general = {
          disable_loading_bar = false;
        };
        background = [
          {
            monitor = "eDP-1";
            # path = "/home/luqman/wallpapers/notseiso/horizontal/suisei-member-july.png";
            path = "/home/luqman/wallpapers/seiso/horizontal/ocean-lock.jpg";
            # color = "rgba(25, 20, 20, 1.0)";
          }
          {
            monitor = "DP-1";
            color = "rgba(25, 20, 20, 1.0)";
          }
        ];
        input-field = [
          {
            size = "200, 50";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(202, 211, 245)";
            inner_color = "rgb(91, 96, 120)";
            outer_color = "rgb(24, 25, 38)";
            outline_thickness = 5;
            placeholder_text = "'Password...'";
            shadow_passes = 2;
          }
        ];
      };
    };
    assertions = [
      {
        assertion = config.modules.core.gui.enable;
        message = "a graphical environment is required";
      }
      {
        assertion = config.modules.core.gui.wmType == "wayland";
        message = "A Wayland environment is required for this module.";
      }
    ];
  };
}
