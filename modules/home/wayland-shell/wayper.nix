{
  flake,
  config,
  lib,
  ...
}:
with lib; let
  inherit (flake) inputs;
  cfg = config.modules.wayland-shell.wayper;
in {
  imports = [inputs.wayper.homeManagerModules.default];

  options.modules.wayland-shell.wayper = {
    enable = mkOption {
      description = "wayper, a wallpaper setter for wayland";
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    services.wayper = {
      enable = true;
      config = {
        default-profile = "default";
        monitorConfigs = [
          {
            name = "eDP-1";
            duration = 60;
            path = "/home/luqman/wallpapers/notseiso/horizontal";
          }
          {
            name = "HDMI-A-1";
            duration = 60;
            path = "/home/luqman/wallpapers/seiso/horizontal";
          }
          {
            name = "DP-1";
            duration = 60;
            path = "/home/luqman/wallpapers/seiso/horizontal";
          }

          # safe
          {
            name = "eDP-1";
            profile = "safe";
            duration = 60;
            path = "/home/luqman/wallpapers/seiso/horizontal";
          }
        ];
      };
    };
  };
}
