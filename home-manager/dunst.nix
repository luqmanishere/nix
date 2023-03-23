{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.dunst;
in {
  imports = [];
  options.dunst = {
    enable = mkOption {
      default = false;
      description = "Enable the dunst notification manager";
      type = types.bool;
    };
  };

  config = mkIf (cfg.enable) {
    home = {
      packages = [
      ];
    };

    services.dunst = {
      enable = true;
      settings = {
        global = {
          monitor = 0;
          follow = "mouse";
          origin = "top-center";
          idle-threshold = 30;
          dmenu = "${pkgs.rofi}/bin/rofi -dmenu -i -p ''";
          layer = "overlay";

          mouse_left_click = "do_action";
          mouse_right_click = "context";

          corner-radius = 10;
          frame_color = "#89B4FA";
          separator_color = "frame";
          max_icon_size = 128;
          min_icon_size = 128;
          font = "Noto Sans Display Nerd Font 12";
        };

        urgency_low = {
          background = "#1E1E2E";
          foreground = "#CDD6F4";
        };

        urgency_normal = {
          background = "#1E1E2E";
          foreground = "#CDD6F4";
        };

        urgency_critical = {
          background = "#1E1E2E";
          foreground = "#CDD6F4";
          frame_color = "#FAB387";
        };
      };
    };
  };
}
