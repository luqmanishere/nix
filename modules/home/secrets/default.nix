{
  flake,
  config,
  lib,
  ...
}:
with lib; let
  inherit (flake) inputs;
  cfg = config.modules.secrets;
in {
  imports = [
    inputs.agenix.homeManagerModules.default
  ];

  options.modules.secrets = {
    enable = mkEnableOption "Enable secrets management with agenix";
    taskd.enable = mkEnableOption "Manage taskd secrets with agenix";
  };

  config = mkIf cfg.enable {
    age = {
      identityPaths = ["/home/luqman/.ssh/agenix" "/home/luqman/.ssh/general"];
      secretsDir = "${config.home.homeDirectory}/.agenix/agenix";
      secretsMountPoint = "${config.home.homeDirectory}/.agenix/agenix.d";

      secrets = mkMerge [
        (mkIf cfg.taskd.enable {
          taskv3_sync.file = ./taskv3_sync.age;
        })
      ];
    };
  };
}
