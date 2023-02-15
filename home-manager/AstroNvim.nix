{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.astronvim;
  astronvim = pkgs.fetchFromGitHub {
    owner = "AstroNvim";
    repo = "AstroNvim";
    rev = "542b9186a5017f8ed4fcbd120244eb550b43c752";
    sha256 = "1spszsd1nhvviwx8v10qa1z7qkvnipkwdg7r8zb9gkaf9iqfnbk3";
  };
in {
  options.astronvim = {
    enable = mkOption {
      default = false;
      description = "Enable AstronVim";
      type = types.bool;
    };

    userConfig = mkOption {
      default = null;
      description = "AstronVim User Config";
      type = with types; nullOr path;
    };
  };
  config = mkIf (cfg.enable) {
    home = {
      file = {
        ".config/nvim" = {
          recursive = true;
          source = astronvim;
        };
        ".config/nvim/lua/user" = mkIf (cfg.userConfig != null) {
          recursive = true;
          source = cfg.userConfig;
        };
      };
    };
  };
}
