{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.hyprland;
in {
  imports = [
    inputs.hyprland.homeManagerModules.default
    inputs.hypridle.homeManagerModules.default
    inputs.hyprlock.homeManagerModules.default
    ./waybar.nix
  ];

  options.hyprland = {
    enable = mkOption {
      default = false;
      description = "Enable hyprland configuration, with swayidle and swaylock";
      type = types.bool;
    };
  };

  config = mkIf (cfg.enable) {
    home = {
      packages = with pkgs; [
        cliphist
        wl-clipboard
        wlr-randr
        swayidle
        swaylock-effects
        grim
        slurp
        inputs.anyrun.packages.${system}.anyrun-with-all-plugins
      ];
      pointerCursor = {
        gtk.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 22;
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      extraConfig = builtins.readFile ./hyprland.conf;
      # package = pkgs.hyprland-hidpi;
    };

    programs.hyprlock = {
      enable = true;
      general = {
        disable_loading_bar = false;
      };
      backgrounds = [
        {
          path = "/home/luqman/wallpapers/notseiso/horizontal/suisei-member-july.png";
        }
      ];
    };

    services.hypridle = {
      enable = true;
      lockCmd = "${inputs.hyprlock.packages.${pkgs.system}.hyprlock}/bin/hyprlock";
      listeners = [
        # turn off screen after 5 minutes
        {
          timeout = 300;
          onTimeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          onResume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        }
        {
          timeout = 360;
          onTimeout = "pgrep hyprlock || loginctl lock-session";
        }
        {
          timeout = 15;
          onTimeout = "pgrep hyprlock && ${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          onResume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        }
      ];
    };

    xdg.configFile."anyrun".source = ./anyrun;
  };
}
