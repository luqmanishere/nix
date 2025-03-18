{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.terminals.kitty;
in {
  imports = [];

  options.modules.terminals.kitty = {
    enable = mkOption {
      default = true;
      description = "Enable the great kitty terminal config";
      type = types.bool;
    };
    fontSize = mkOption {
      default = 16.0;
      description = "Customize font size";
      type = types.float;
    };
  };

  config = mkIf (cfg.enable) {
    home = {
      packages = with pkgs; [
        kitty
      ];
    };

    programs.kitty = {
      enable = true;
      font = {
        name = "Maple Mono NF";
        size = cfg.fontSize;
      };
      theme = "Catppuccin-Mocha";
      extraConfig = ''
        macos_option_as_alt yes
      '';
    };

    assertions = [
      {
        assertion = config.modules.core.gui.enable;
        message = "A graphical environment is required";
      }
    ];
  };
}
