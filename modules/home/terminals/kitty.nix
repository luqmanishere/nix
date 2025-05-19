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
      default = false;
      description = "Enable the great kitty terminal config";
      type = types.bool;
    };
    fontSize = mkOption {
      default = 16.0;
      description = "Customize font size";
      type = types.float;
    };
    mapleFont = mkEnableOption "Use MapleMonoNF font";
  };

  config = mkIf (cfg.enable) {
    home = {
      packages = with pkgs; [
        kitty
      ];
    };

    programs.kitty = {
      enable = true;
      font = mkIf cfg.mapleFont {
        name = "Maple Mono NF";
        size = cfg.fontSize;
      };
      themeFile = "Catppuccin-Mocha";
      extraConfig = mkMerge [
        ''
          macos_option_as_alt yes
          map alt+1 goto_tab 1
          map alt+2 goto_tab 2
          map alt+3 goto_tab 3
          map alt+4 goto_tab 4
          map alt+5 goto_tab 5
          map alt+shift+\ launch --location vsplit
          map alt+- launch --location hsplit
          map alt+shift+c new_tab --cwd
        ''
        (mkIf cfg.mapleFont ''
          font_features MapleMonoNF-Regular +calt -zero -cv01 -cv02 -cv03 -cv04 ss01 -ss02 ss03
          font_features MapleMonoNF-LightItalic +calt -zero -cv01 -cv02 -cv03 -cv04 ss01 -ss02 ss03
          font_features MapleMonoNF-Italic +calt -zero -cv01 -cv02 -cv03 -cv04 ss01 -ss02 ss03
          font_features MapleMonoNF-BoldItalic +calt -zero -cv01 -cv02 -cv03 -cv04 ss01 -ss02 ss03
          font_features MapleMonoNF-Light +calt -zero -cv01 -cv02 -cv03 -cv04 ss01 -ss02 ss03
          font_features MapleMonoNF-Bold +calt -zero -cv01 -cv02 -cv03 -cv04 ss01 -ss02 ss03
        '')
      ];
    };

    assertions = [
      {
        assertion = config.modules.core.gui.enable;
        message = "A graphical environment is required";
      }
    ];
  };
}
