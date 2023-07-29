{ config
, pkgs
, lib
, ...
}:
with lib; let
  cfg = config.modules.terminals.zellij;
in
{
  imports = [ ];

  options.modules.terminals.zellij = {
    enable = mkEnableOption "enable zellij";
  };

  config = mkMerge [
    (mkIf (cfg.enable) {
      programs.zellij = {
        enable = true;
      };
      xdg.configFile."zellij/config.kdl".source = ./config.kdl;
    })
  ];
}
