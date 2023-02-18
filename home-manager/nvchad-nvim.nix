{ config
, pkgs
, lib
, ...
}:
with lib; let
  cfg = config.nvchad;
  nvchad = pkgs.fetchFromGitHub {
    owner = "NvChad";
    repo = "NvChad";
    rev = "32b0a008a96a3dd04675659e45a676b639236a98";
    sha256 = "IfVcysO6LTm7xFv5m7+GExmplj0P+IVGSeoMCT9qvBY=";
  };
in
{
  options.nvchad = {
    enable = mkOption {
      default = false;
      description = "Enable nvchad.nvim";
      type = types.bool;
    };

    userConfig = mkOption {
      default = null;
      description = "nvchad User Config";
      type = with types; nullOr path;
    };
  };
  config = mkIf (cfg.enable) {
    home = {
      file = {
        ".config/nvim" = {
          recursive = true;
          source = nvchad;
        };
        ".config/nvim/lua/custom" = mkIf (cfg.userConfig != null) {
          recursive = true;
          source = cfg.userConfig;
        };
      };
      packages = with pkgs; [
        nodejs
        ripgrep
        python3
      ];
    };
  };
}
