{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.wayland-shell.waybar;
in {
  options.modules.wayland-shell.waybar = {
    enable = mkOption {
      default = false;
      description = "Enable waybar, a wayland bar";
      type = types.bool;
    };
    wm = mkOption {
      type = types.enum ["hyprland" "niri"];
      default = config.modules.core.gui.wmName;
      description = "The wm waybar is configured for";
    };
    width = mkOption {
      default = 1800;
      description = "Width of the bar";
      type = types.int;
    };
    height = mkOption {
      default = 30;
      description = "Height of the bar";
      type = types.int;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      font-awesome_5
      pwvucontrol
    ];
    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        # no longer needed
        # target = "hyprland-session.target";
      };
      style = ./style.css;
      # settings = builtins.fromJSON (builtins.readFile ./config.json);
      settings = import ./config.nix {
        inherit lib config;
        width = cfg.width;
        height = cfg.height;
        wm = cfg.wm;
      };
      package = pkgs.waybar;
    };
    assertions = [
      {
        assertion = config.modules.core.gui.enable;
        message = "a graphical environment is required";
      }
    ];
  };
}
