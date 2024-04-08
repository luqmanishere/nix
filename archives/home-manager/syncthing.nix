{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.syncthing;
in {
  imports = [];

  options.syncthing = {
    enable = mkOption {
      description = "enable syncthing";
      default = true;
      type = types.bool;
    };
  };

  config = mkIf (cfg.enable) {
    services.syncthing = {
      enable = true;
    };
  };
}
