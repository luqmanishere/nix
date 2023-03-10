{ config, pkgs, lib, ... }: with lib;
let cfg = config.services.a2ln; in {
  imports = [ ];

  options.services = {
    a2ln = {
      enable = mkEnableOption "android 2 linux notification server";
      package = mkOption {
        description = "a2ln server package";
        type = types.package;
        default = pkgs.a2ln;
      };
      target = mkOption {
        description = "Start after target";
        type = types.str;
        default = "graphical-session.target";
      };
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = [ cfg.package ];

    systemd.user.services.a2ln = {
      Unit = {
        Description = "Android 2 Linux notification server";
        After = [ cfg.target ];
      };

      Service = {
        ExecStart = "${cfg.package}/bin/a2ln --no-pairing-server";
      };

      Install = { WantedBy = [ cfg.target ]; };
    };
  };
}
