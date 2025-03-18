{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.editors.vscode;
in {
  options.modules.editors.vscode = {
    enable = lib.mkEnableOption "enable the vscode editor";
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
    };
  };
}
