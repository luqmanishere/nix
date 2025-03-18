{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.editors.neovide;
in {
  options.modules.editors.neovide = {
    enable = lib.mkEnableOption "Enable Neovide, the graphical frontend for neovim";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [neovide];

    assertions = [
      {
        assertion = config.modules.core.gui.enable;
        message = "This module requires a graphical environment";
      }
    ];
  };
}
