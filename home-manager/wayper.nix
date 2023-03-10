{ config, pkgs, lib, ... }: with lib;
let cfg = config.wayper;
in {
  imports = [ ];

  options = {
    wayper = {
      enable = mkOption {
        description = "wayper, a wallpaper setter for wayland";
        default = false;
        type = types.bool;
      };

      package = mkOption {
        type = types.package;
        default = pkgs.wayper;
        defaultText = literalExpression "pkgs.wayper";
        description = "Package providing wayper";
      };

      systemdIntegration = {
        enable = mkOption {
          description = "enable systemd service";
          type = types.bool;
          default = false;
        };
        target = mkOption {
          description = "Start after target";
          type = types.str;
          default = "graphical-session.target";
        };
      };

    };
  };

  config = mkIf (cfg.enable) {
    home.packages = [
      cfg.package
    ];

    systemd.user.services.wayper = mkIf (cfg.systemdIntegration.enable) {
      Unit = {
        Description = "Wayland wallpaper setter";
        After = [ cfg.systemdIntegration.target ];
      };

      Service = {
        ExecStart = "${cfg.package}/bin/wayper";
      };

      Install = { WantedBy = [ cfg.systemdIntegration.target ]; };
    };
  };
}
