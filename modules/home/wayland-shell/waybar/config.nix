{
  lib,
  width,
  height,
  wm,
}:
with lib; let
  inherit width;
  inherit height;

  hyprland_workspaces_module = "hyprland/workspaces";
  hyprland_workspaces_set = {
    "disable-scroll" = true;
    "all-outputs" = false;
    "format" = "{id}";
    "format-icons" = {
      "1" = "";
      "2" = "";
      "3" = "";
      "4" = "";
      "5" = "";
      "urgent" = "";
      "focused" = "";
      "default" = "";
    };
    "on-click" = "activate";
  };
  hyprland_window_module = "hyprland/window";
  hyprland_window_set = {
    "format" = "{}";
    "max-length" = 30;
  };

  niri_workspaces_module = "niri/workspaces";
  niri_workspace_set = {
    "disable-scroll" = true;
    "all-outputs" = false;
  };
  niri_window_module = "niri/window";
  niri_window_set = {
    "format" = "{title}";
    "max-length" = 30;
  };
in [
  {
    layer = "top";
    "position" = "top";
    "height" = height;
    "output" = "eDP-1";
    "width" = width;
    "spacing" = 4;
    "margin-top" = 10;
    "name" = "ayaya";

    reload_style_on_change = true;

    "modules-left" = [
      (mkIf (wm == "hyprland") hyprland_workspaces_module)
      (mkIf (wm == "niri") niri_workspaces_module)
    ];
    modules-center = ["clock"];
    modules-right = [
      "wireplumber"
      "network"
      "cpu"
      "memory"
      "battery"
      "temperature"
      "backlight"
    ];
    "${hyprland_workspaces_module}" = hyprland_workspaces_set;
    "${niri_workspaces_module}" = niri_workspace_set;
    idle_inhibitor = {
      format = "{icon}";
      format-icons = {
        activated = "";
        deactivated = "";
      };
    };
    tray = {
      icon-size = 21;
      spacing = 10;
    };
    clock = {
      format = "{:%H:%M} ";
      format-alt = "{:%A, %B %d, %Y (%R)}  ";
      tooltip-format = "<tt><small>{calendar}</small></tt>";
      calendar = {
        mode = "year";
        mode-mon-col = 3;
        weeks-pos = "right";
        on-scroll = 1;
        format = {
          months = "<span color='#ffead3'><b>{}</b></span>";
          days = "<span color='#ecc6d9'><b>{}</b></span>";
          weeks = "<span color='#99ffdd'><b>W{}</b></span>";
          weekdays = "<span color='#ffcc66'><b>{}</b></span>";
          today = "<span color='#ff6699'><b><u>{}</u></b></span>";
        };
      };
      actions = {
        on-click-right = "mode";
        on-scroll-up = "shift_up";
        on-scroll-down = "shift_down";
      };
    };
    cpu = {
      format = "{usage}% ";
      tooltip = false;
    };
    memory = {
      format = "{}% ";
    };
    temperature = {
      thermal-zone = 2;
      hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
      critical-threshold = 80;
      format-critical = "{temperatureC}°C {icon}";
      format = "{temperatureC}°C {icon}";
      format-icons = [
        ""
        ""
        ""
      ];
    };
    backlight = {
      device = "amdgpu_bl0";
      format = "{percent}% {icon}";
      format-icons = [
        ""
        ""
        ""
        ""
        ""
        ""
        ""
        ""
        ""
      ];
    };
    battery = {
      states = {
        good = 95;
        warning = 30;
        critical = 15;
      };
      format = "{capacity}% {icon} ";
      format-charging = "{capacity}% 󰂄";
      format-plugged = "{capacity}% ";
      format-alt = "{time} {icon}";
      format-good = "{capacity}% {icon}";
      format-full = "{capacity}% {icon}";
      format-icons = [
        ""
        ""
        ""
        ""
        ""
      ];
    };
    network = {
      format-wifi = "{ifname} ({signalStrength}%)  ";
      format-ethernet = "{ifname} ({signalStrength}%) 󰈀";
      # format-ethernet = "{ipaddr}/{cidr} 󰈀";
      tooltip-format = "{ipaddr} via {gwaddr} 󰈀";
      format-linked = "{ifname} (No IP) 󰈀";
      format-disconnected = "Disconnected ⚠";
      format-alt = "{ifname}= {ipaddr}/{cidr}";
      # interface = "wlan0";
    };
    pulseaudio = {
      scroll-step = 1;
      format = "{volume}% {icon} {format_source}";
      format-bluetooth = "{volume}% {icon} {format_source}";
      format-bluetooth-muted = "󰝟 {icon} {format_source}";
      format-muted = "󰝟 {format_source}";
      format-source = "{volume}% ";
      format-source-muted = "";
      format-icons = {
        headphone = "";
        hands-free = "󰋎";
        headset = "󰋎";
        phone = "";
        portable = "";
        car = "";
        default = [
          ""
          ""
          ""
        ];
      };
      on-click = "pavucontrol";
    };
    wireplumber = {
      format = "{volume}% {icon} ";
      format-muted = "󰝟 muted";
      on-click = "pwvucontrol";
      format-icons = [
        ""
        ""
        ""
      ];
    };
  }
  {
    output = "eDP-1";
    layer = "top";
    position = "bottom";
    height = height;
    width = width;
    spacing = 4;
    margin-bottom = 10;
    name = "bot";
    modules-left = [
      "hyprland/submap"
      "tray"
    ];
    modules-center = [
      (mkIf (wm == "hyprland") hyprland_window_module)
      (mkIf (wm == "niri") niri_window_module)
    ];
    modules-right = [
      "mpd"
    ];
    "${hyprland_window_module}" = hyprland_window_set;
    "${niri_window_module}" = niri_window_set;
    mpd = {
      format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {title} ⸨{songPosition}|{queueLength}⸩ {volume}% ";
      format-disconnected = "Disconnected ";
      format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
      unknown-tag = "N/A";
      interval = 2;
      consume-icons = {
        on = " ";
      };
      random-icons = {
        off = "<span color=\"#f53c3c\"></span> ";
        on = " ";
      };
      repeat-icons = {
        on = " ";
      };
      single-icons = {
        on = "1 ";
      };
      state-icons = {
        paused = "";
        playing = "";
      };
      tooltip-format = "MPD (connected)";
      tooltip-format-disconnected = "MPD (disconnected)";
    };
    idle_inhibitor = {
      format = "{icon}";
      format-icons = {
        activated = "";
        deactivated = "";
      };
    };
    tray = {
      icon-size = 21;
      spacing = 10;
    };
    "hyprland/submap" = {
      format = "hypr={}";
      max-length = 20;
      tooltip = true;
    };
  }
]
