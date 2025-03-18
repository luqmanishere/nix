{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.browsers.firefox;
in {
  imports = [];

  options.modules.browsers.firefox = {
    enable = mkOption {
      default = false;
      description = "enable the firefox browser";
      type = types.bool;
    };
  };

  config = mkIf (cfg.enable) {
    programs.firefox = {
      enable = true;
      profiles."solemnattic" = {
        name = "solemnattic";
        isDefault = true;
      };
    };

    assertions = [
      {
        assertion = config.modules.core.gui.enable;
        message = "a window manager module must be enabled!";
      }
    ];
  };
}
