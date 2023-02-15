{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.nyoom;
  nyoom = pkgs.fetchFromGitHub {
    owner = "nyoom-engineering";
    repo = "nyoom.nvim";
    rev = "f7bb5adbef6700403360d141952ea1e7bf53f46b";
    sha256 = "TEhK09gL6DW3y0Fp7maG2vh3wfE5WRLnwiD6+eGE+zE=";
  };
in {
  options.nyoom = {
    enable = mkOption {
      default = false;
      description = "Enable nyoom.nvim";
      type = types.bool;
    };

    userConfig = mkOption {
      default = null;
      description = "nyoom User Config";
      type = with types; nullOr path;
    };
  };
  config = mkIf (cfg.enable) {
    home = {
      file = {
        ".config/nvim" = {
          recursive = true;
          source = nyoom;
        };
        ".config/nyoom" = mkIf (cfg.userConfig != null) {
          recursive = true;
          source = cfg.userConfig;
        };
      };
    };
  };
}
