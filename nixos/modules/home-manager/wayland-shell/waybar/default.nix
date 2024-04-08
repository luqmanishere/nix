{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.waybar;
in {
  imports = [];

  options.waybar = {
    enable = mkOption {
      default = true;
      description = "Enable waybar, a bar";
      type = types.bool;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      font-awesome_5
      helvum
    ];
    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };
      style = ./style.css;
      settings = builtins.fromJSON (builtins.readFile ./config.json);
      package = pkgs.waybar;
    };
  };
}
