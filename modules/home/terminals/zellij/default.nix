{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.terminals.zellij;
in {
  imports = [];

  options.modules.terminals.zellij = {
    enable = mkEnableOption "enable zellij";
  };

  config = mkMerge [
    (mkIf (cfg.enable) {
      programs.zellij = {
        enable = true;
        enableFishIntegration = lib.mkForce false;
      };
      xdg.configFile."zellij/config.kdl".source = ./config.kdl;
      xdg.configFile."zellij/layouts/default.kdl".source = ./layouts/default.kdl;
    })
  ];
}
