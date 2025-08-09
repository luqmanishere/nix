{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  inherit (flake) inputs;
  cfg = config.modules.wayland-shell.quickshell;
in {
  imports = [];

  options.modules.wayland-shell.quickshell = {
    enable = mkOption {
      description = "wayper, a wallpaper setter for wayland";
      default = false;
      type = types.bool;
    };

    package = mkOption {
      description = "quickshell package";
      default = inputs.quickshell.packages.${pkgs.system}.default;
      type = types.package;
    };
  };

  # config = mkIf cfg.enable {
  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
      pkgs.kdePackages.qtdeclarative
    ];
    qt.enable = true;

    systemd.user.services.quickshell = {
      Unit = {
        Description = "Quickshell custom shell";
        After = ["graphical-session.target"];
      };

      Service = {
        ExecStart = "${getExe cfg.package}";
        Restart = "on-failure";
        RestartSec = 3;
      };

      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
