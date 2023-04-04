{
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.hyprland;
  lock = "${pkgs.swaylock-effects}/bin/swaylock -f --clock --indicator --indicator-idle-visible --fade-in 1 -c 000000";
  screenoff = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
  screenon = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
  lockscreenoff = "${pkgs.procps}/bin/pgrep swaylock && ${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
  lockscreenon = "${pkgs.procps}/bin/pgrep swaylock && ${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
in {
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./waybar.nix
    ./wayper.nix
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
      systemdIntegration = true;
      recommendedEnvironment = true;
      extraConfig = builtins.readFile ./hyprland.conf;
      package = pkgs.hyprland-hidpi;
    };

    services.swayidle = {
      enable = true;
      systemdTarget = "hyprland-session.target";

      events = [
        {
          event = "before-sleep";
          command = "${lock}";
        }
        {
          event = "lock";
          command = "${lock}";
        }
      ];

      timeouts = [
        {
          timeout = 360;
          command = "${lock}";
        }
        {
          timeout = 300;
          command = "${screenoff}";
          resumeCommand = "${screenon}";
        }
        {
          timeout = 15;
          command = "${lockscreenoff}";
          resumeCommand = "${lockscreenon}";
        }
      ];
    };
  };
}
