{
  flake,
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (flake) inputs;
  cfg = config.modules.wayland-shell.kanshi;
in {
  options.modules.wayland-shell.kanshi = {
    enable = lib.mkEnableOption "Enable kanshi monitor sorter";
    systemdTarget = lib.mkOption {
      type = lib.types.string;
      default = "hyprland-session.target";
    };
  };
  config = lib.mkIf cfg.enable {
    services.kanshi = {
      enable = true;
      systemdTarget = cfg.systemdTarget;
      settings = [
        # FIXME: why is this even broken
        # {
        #   output = {
        #     criteria = "eDP-1";
        #     mode = "1920x1080@60.01Hz";
        #   };
        # }

        {
          profile.name = "docked_home";
          profile.outputs = [
            {
              criteria = "eDP-1";
              position = "0,0";
            }
            {
              # this monitor sits on top
              criteria = "Dell Inc. DELL U2713HM 7JNY5496050S";
              position = "-320,-1440"; # this is the (difference in x) / 2 and and monitor size in y
              mode = "2560x1440@59.95Hz";
            }
          ];
        }
        {
          profile.name = "undocked";
          profile.outputs = [
            {
              criteria = "eDP-1";
              position = "0,0";
            }
          ];
        }
      ];
    };
    assertions = [
      {
        assertion = config.modules.core.gui.enable;
        message = "a wayland graphical environment is required";
      }
    ];
  };
}
