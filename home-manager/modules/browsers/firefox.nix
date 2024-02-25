{
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.browsers.firefox;
in {
  imports = [];

  options.modules.browsers.firefox = {
    enable = mkEnableOption "enable firefox browser";
  };

  config = mkMerge [
    (mkIf (cfg.enable) {
      programs.firefox = {
        enable = true;
        profiles."solemnattic" = {
          name = "solemnattic";
          isDefault = true;
        };
      };
      # xdg.configFile."zellij/config.kdl".source = ./config.kdl;
    })
  ];
}
