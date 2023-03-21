{ config, inputs, lib, pkgs, ... }:
with lib;
let
  cfg = config.oci-script;
  name = "oci-script";
in
{
  imports = [ ];

  options.oci-script.enable = mkEnableOption "bruh";

  config =
    let
      phpBin = "${pkgs.php82}/bin/php";
      script = name: pkgs.writeShellScript "${name}.sh" ''
        set -eou pipefail
        PATH=/run/current-system/sw/bin:
        cd ${config.home.homeDirectory}/projects/oci-arm-host-capacity
        ${phpBin} ./index.php | ${pkgs.jq}/bin/jq ".message" >> ${config.home.homeDirectory}/oci-run-log
      '';
    in
    mkIf (cfg.enable) {
      systemd.user.services.oci-script = {
        Unit = {
          Description = "script to run oci-thing";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
        Service = {
          ExecStart = "${script name}";
        };
      };
      systemd.user.timers.oci-script = {
        Install = {
          WantedBy = [ "timers.target" ];
        };
        Timer = {
          OnStartupSec = "1m";
          #OnActiveSec = "1m";
          OnUnitActiveSec = "1m";
        };
      };
    };
}
