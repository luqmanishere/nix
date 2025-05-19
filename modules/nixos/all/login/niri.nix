{
  flake,
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  inherit (flake) inputs;
  inherit (inputs) niri-flake;
  cfg = config.modules.wm.niri;
in {
  options.modules.wm.niri = {enable = mkEnableOption "Enable the niri wm";};

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nautilus # required for file picking with gnome portal
      adwaita-icon-theme
    ];

    programs.niri.enable = true;
    programs.dconf.enable = true;
  };

  imports = [
    niri-flake.nixosModules.niri
  ];
}
