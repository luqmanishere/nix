{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.wayland-shell.ags;
in {
  imports = [inputs.ags.homeManagerModules.default];

  options.modules.wayland-shell.ags = {
    enable = mkEnableOption "enable ags shell";
  };

  config = mkMerge [
    (mkIf (cfg.enable) {
      programs.ags = {
        enable = true;
        # configDir = ./ags-config;
      };
      home.packages = with pkgs; [bun sassc];
    })
  ];
}
