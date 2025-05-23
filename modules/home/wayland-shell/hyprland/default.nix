{
  flake,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  inherit (flake) inputs;
  cfg = config.hyprland;
in {
  imports = [
    inputs.hyprland.homeManagerModules.default
    inputs.hyprrdrop.homeManagerModules.default
  ];

  options.hyprland = {
    enable = mkOption {
      default = false;
      description = "Enable hyprland graphical window configuration";
      type = types.bool;
    };
  };

  config = mkIf (cfg.enable) {
    modules.core.gui = {
      enable = true;
      wmName = "hyprland";
      wmType = "wayland";
    };

    home = {
      # TODO: split up
      packages = with pkgs; [
        cliphist
        wl-clipboard
        wlr-randr
        swayidle
        swaylock-effects
        grim
        slurp
        # TODO: maybe move this?
        pavucontrol
      ];
      pointerCursor = {
        gtk.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 22;
      };
    };
    programs.hyprrdrop.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;
      systemd = {
        enable = true;
        variables = ["--all"];
      };
      settings = {
        input = {
          follow_mouse = 1;
          touchpad = {
            natural_scroll = true;
            disable_while_typing = true;
            tap-to-click = true;
          };

          sensitivity = 0;
        };

        general = {
          gaps_in = 5;
          gaps_out = 15;
          border_size = 6;

          "col.active_border" = "rgb(f5bde6)";
          "col.inactive_border" = "rgb(7dc4e4)";

          # apply_sens_to_raw = 1;

          layout = "master";
        };

        decoration = {
          rounding = 10;

          blur = {
            enabled = true;
            size = 8;
            passes = 1;
            new_optimizations = true;
          };

          active_opacity = 0.95;
          inactive_opacity = 0.85;
          fullscreen_opacity = 1.0;
        };

        animations = {
          enabled = true;
          first_launch_animation = true;
        };

        misc = {
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;
        };

        master = {
          new_status = "master";
          mfact = 0.7;
          # no_gaps_when_only = false;
          always_center_master = true;
          special_scale_factor = 0.7;
        };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_fingers = 4;
        };

        monitor = [
        ];

        # TODO: other stuff
        # workspace = [];

        # TODO: optimize with functions
        windowrule = [
          "float, Minecraft"
          "float, lutris"
          "opaque, Minecraft"
          "float, steam"
          "opaque, steam"
          "float, dota2"
          "opaque, dota2"
          "float, Waydroid"
          "opaque, Waydroid"
          "float, title: Picture in picture"
          "pin, title: Picture in picture"
          "float, title: muzik - music manager"
        ];

        # TODO: optimize with functions
        windowrulev2 = [
          "float, title:(Picture-in-Picture)"
          "pin, title:(Picture-in-Picture)"
          "opaque, title:(Picture-in-Picture)"
          "float, title:(muzik)"
          "opaque, title:(muzik)"
          "float, class:(ayaya-project-manager)"
          "opaque, class:(ayaya-project-manager)"
          "float, class:(Ayaya-project-manager)"
          "opaque, class:(Ayaya-project-manager)"
          "float, title:(Extension: (Raindrop.io) - Bookmark saved — Mozilla Firefox)"
          "float, title:(com.github.Aylur.ags)"
          "move 25% 85%, title:(com.github.Aylur.ags)"
          "noinitialfocus, title:(com.github.Aylur.ags)"
          "float, class:(waydroid.*)"

          "animation slide, class:(pavucontrol)"
          "float, class:(pavucontrol)"
          "size 80% 50%, class:(pavucontrol)"
        ];

        # TODO: segregate these into logical sections
        bind = [
          ### wm controls
          "ALT, Tab, cyclenext"
          "ALT, Tab, bringactivetotop"
          "SUPER, P, pseudo"
          "SUPERSHIFT, P, pin"
          "SUPER, F, fullscreen"
          "SUPERSHIFT, F, fullscreen, 1"
          "SUPERSHIFT, Q, exit"
          "SUPER, J, togglefloating"
          "SUPERSHIFT, O, exec, hyprctl setprop active opaque toggle"
          "SUPERSHIFT, J, workspaceopt, allfloat"
          "SUPER, G, togglegroup"
          "SUPERSHIFT, G, moveintogroup"
          "SUPER, grave, changegroupactive, f"

          "SUPER, left, movefocus, l"
          "SUPER, right, movefocus, r"
          "SUPER, up, movefocus, u"
          "SUPER, down, movefocus, d"
          "SUPER, h, movefocus, l"
          "SUPER, l, movefocus, r"
          "SUPER, k, movefocus, u"
          "SUPER, j, movefocus, d"

          # TODO: optimize with function
          "SUPER, 1, workspace, 1"
          "SUPER, 2, workspace, 2"
          "SUPER, 3, workspace, 3"
          "SUPER, 4, workspace, 4"
          "SUPER, 5, workspace, 5"
          "SUPER, 6, workspace, 6"
          "SUPER, 7, workspace, 7"
          "SUPER, 8, workspace, 8"
          "SUPER, 9, workspace, 9"

          "ALT, 1, movetoworkspacesilent, 1"
          "ALT, 2, movetoworkspacesilent, 2"
          "ALT, 3, movetoworkspacesilent, 3"
          "ALT, 4, movetoworkspacesilent, 4"
          "ALT, 5, movetoworkspacesilent, 5"
          "ALT, 6, movetoworkspacesilent, 6"
          "ALT, 7, movetoworkspacesilent, 7"
          "ALT, 8, movetoworkspacesilent, 8"
          "ALT, 9, movetoworkspacesilent, 9"

          ## scroll to change workspace
          "SUPER, mouse_down, workspace, e+1"
          "SUPER, mouse_up, workspace, e-1"

          ### execs
          "SUPER, Q, exec, kitty"
          "SUPER, RETURN, exec, alacritty"
          "SUPER, C, killactive"
          "SUPER, E, exec, dolphin"
          "SUPER, R, exec, $HOME/.config/rofi/bin/launcher"
          "ALT, SPACE, exec, anyrun"

          # FIXME: these should be in a submap
          "SUPERSHIFT, B, exec, killall -SIGUSR2 waybar" # waybar reload
          "SUPERSHIFT, N, exec, killall -SIGUSR1 waybar" # waybar hide

          "SUPERSHIFT, L, exec, loginctl lock-session && sleep 5 && hyprctl dispatch dpms off"
          "SUPERSHIFT, S, exec, grim -g \"\$(${lib.getExe pkgs.slurp})\" "

          # FIXME: WTH IS THIS?
          "SUPER, T, exec, /home/luqman/scripts/autoclicktrigger.sh"

          ### audio control
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

          ", XF86MonBrightnessUp, exec, light -A 5"
          ", XF86MonBrightnessDown, exec, light -U 5"

          # submaps can't really be defined here due to requiring multiple submap calls and consolidated bind calls

          # SUPERSHIFT, 1
          "SUPERSHIFT, 1, exec, hyprrdrop toggle quick-1 || hyprrdrop register active quick-1"
        ];

        animation = [
          "windows, 1, 7, default"
          "border, 1, 10, default"
          "fade, 1, 10, default"
          "workspaces, 1, 6, default"
          "specialWorkspace, 1, 10, default, slidefadevert"
        ];
      };
      extraConfig = builtins.readFile ./hyprland.conf;
    };
  };
}
