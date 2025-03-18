{
  flake,
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (flake) self;
  cfg = config.modules.productivity.essentials;
in {
  options.modules.productivity.essentials = {
    enable = lib.mkEnableOption "Enable essential graphical programs";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      obsidian
      zathura
      self.packages.${pkgs.system}.siyuan-unlock
    ];

    assertions = [
      {
        assertion = config.modules.core.gui.enable;
        message = "A graphical environment is required.";
      }
    ];
  };
}
