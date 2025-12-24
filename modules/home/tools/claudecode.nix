{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.tools.claudecode;
in {
  options.modules.tools.claudecode = {
    enable = mkEnableOption "Enable the Claude Code agent";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [claude-code opencode];
  };
}
