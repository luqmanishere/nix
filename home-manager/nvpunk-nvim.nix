{ config
, pkgs
, lib
, ...
}:
with lib; let
  cfg = config.nvpunk;
  nvpunk = pkgs.fetchFromGitLab {
    owner = "gabmus";
    repo = "nvpunk";
    rev = "f23b2118277dba6efc9af38df1831ac0cde0a5ef";
    sha256 = "jLFhnD2QdakXFXF+leBeThIYc6OXY5dQFO6vwyolS6w=";
  };
in
{
  options.nvpunk = {
    enable = mkOption {
      default = false;
      description = "Enable nvpunk.nvim";
      type = types.bool;
    };

    userConfig = mkOption {
      default = null;
      description = "nvpunk User Config";
      type = with types; nullOr path;
    };
  };
  config = mkIf (cfg.enable) {
    home = {
      file = {
        ".config/nvim" = {
          recursive = true;
          source = nvpunk;
        };
        ".config/nvpunk/lua/user" = mkIf (cfg.userConfig != null) {
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
