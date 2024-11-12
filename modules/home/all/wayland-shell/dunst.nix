{
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
      default = true;
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
          idle-threshold = 30;
          dmenu = "${pkgs.rofi}/bin/rofi -dmenu -i -p ''";
          layer = "overlay";
          notification_limit = 5;
          progress_bar = true;

          origin = "top-right";
          width = "(0,500)";
          height = 150;
          offset = "80x30";

          mouse_left_click = "do_action";
          mouse_right_click = "context";
          mouse_middle_click = "close_all";

          corner-radius = 10;
          frame_color = "#89B4FA";
          separator_color = "frame";
          max_icon_size = 100;
          min_icon_size = 100;
          gap_size = 2;
          font = "Noto Sans Display Nerd Font 12";
        };

        urgency_low = {
          background = "#1E1E2E";
          foreground = "#CDD6F4";
          timeout = 5;
        };

        urgency_normal = {
          background = "#1E1E2E";
          foreground = "#CDD6F4";
          timeout = 5;
        };

        urgency_critical = {
          background = "#1E1E2E";
          foreground = "#CDD6F4";
          frame_color = "#FAB387";
          timeout = 5;
        };
      };
    };
  };
}
