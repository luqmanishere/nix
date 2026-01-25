{inputs, ...}: {
  flake.modules.homeManager.quickshell = {
    lib,
    pkgs,
    ...
  }: let
    package = inputs.quickshell.packages.${pkgs.system}.default;
  in
    with lib; {
      home.packages = with pkgs; [
        package
        pkgs.kdePackages.qtdeclarative

        material-symbols
      ];
      qt.enable = true;

      systemd.user.services.quickshell = {
        Unit = {
          Description = "Quickshell custom shell";
          After = ["graphical-session.target"];
        };

        Service = {
          ExecStart = "${getExe package}";
          Restart = "on-failure";
          RestartSec = 3;
        };

        Install = {
          WantedBy = ["default.target"];
        };
      };
    };
}
