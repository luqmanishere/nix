{ inputs, config, pkgs, lib, ... }:
with lib;
let
  cfg = config.waybar;
in
{
  imports = [ ];

  options.waybar = {
    enable = mkOption {
      default = false;
      description = "Enable waybar, a bar";
      type = types.bool;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs;[

      font-awesome_5
    ];
    programs.waybar = {
      enable = true;
      systemd = {
        # this is somehow broken, so we start waybar from Hyprland
        enable = false;
        target = "hyprland-session.target";
      };
      style = ./waybar/style.css;
      settings = builtins.fromJSON (builtins.readFile ./waybar/config);
    };
  };
}
