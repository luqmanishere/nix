{
  flake,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) zen-browser;
  cfg = config.modules.browsers.zen;
in {
  options.modules.browsers.zen = {
    enable = lib.mkEnableOption "Enable the Zen browser.";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      zen-browser.packages."${pkgs.system}".default
    ];

    assertions = [
      {
        assertion = config.modules.core.gui.enable;
        message = "a window manager module must be enabled!";
      }
    ];
  };
}
