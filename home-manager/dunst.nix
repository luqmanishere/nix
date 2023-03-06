{ inputs, config, pkgs, lib, ... }:
with lib; let
  cfg = config.dunst;
in
{
  imports = [ ];
  options.dunst = {
    enable = mkOption {
      default = false;
      description = "Enable the dunst notification manager";
      type = types.bool;
    };
  };

  config = mkIf (cfg.enable) {
    home = {
      packages = [

      ];
    };

    services.dunst = {
      enable = true;
      configFile = "";
      settings = { };
    };
  };
}
