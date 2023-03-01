{ config, pkgs, lib, ... }:
with lib; let
  cfg = config.lazyvim;
in
{
  options.lazyvim = {
    enable = mkOption {
      default = false;
      description = "Enable lazyvim";
      type = types.bool;
    };

    userConfig = mkOption {
      default = null;
      description = "lazyvim extra config";
      type = with types; nullOr path;
    };
  };
  config = mkIf (cfg.enable) {
    home = {
      file = {
        ".config/nvim" = {
          recursive = true;
          source = ./lazyvim-conf;
        };
        ".config/nvim/lua/custom" = mkIf (cfg.userConfig != null) {
          recursive = true;
          source = cfg.userConfig;
        };
      };
      packages = with pkgs; [
        # telescope dependency
        ripgrep
        # build language servers
        nodejs
        python3
        cargo
        lua51Packages.jsregexp
        unzip
        # for git ui
        lazygit
      ];
    };
  };
}
