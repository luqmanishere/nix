{
  flake,
  config,
  lib,
  pkgs,
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
    home.packages = with pkgs; [matugen];
    services.wayper = {
      enable = true;
      enableFuzzelIntegration = true;
      enableFishCompletions = true;
      config = {
        default-profile = "default";
        transitions = {enable = true;};
        monitorConfigs = [
          {
            name = "eDP-1";
            duration = 60;
            path = "/home/luqman/wallpapers/notseiso/horizontal";
            run_command = "matugen image {image}";
            transitions = {
              enable = true;
              duration = 2000;
              fps = 60;
            };
          }
          {
            name = "HDMI-A-1";
            duration = 60;
            path = "/home/luqman/wallpapers/seiso/horizontal";
            run_command = "matugen image {image}";
          }
          {
            name = "DP-1";
            duration = 60;
            path = "/home/luqman/wallpapers/seiso/horizontal";
            run_command = "matugen image {image}";
          }

          # safe
          {
            name = "eDP-1";
            profile = "safe";
            duration = 60;
            path = "/home/luqman/wallpapers/seiso/horizontal";
            run_command = "matugen image {image}";
          }
        ];
      };
    };
  };
}
