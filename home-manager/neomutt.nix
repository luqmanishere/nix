{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.neomutt;
in {
  imports = [];

  options.neomutt = {
    enable = mkOption {
      default = false;
      description = "Enable neomutt";
      type = types.bool;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [urlscan lynx];
    programs.neomutt = {
      enable = true;
    };
    programs.gpg.enable = true;
  };
}
