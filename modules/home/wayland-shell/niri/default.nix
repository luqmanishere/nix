{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  inherit (flake) inputs;
  inherit (inputs) niri-flake;
  cfg = config.modules.wayland-shell.niri;
in {
  # this is not needed because the flake auto imports in the nixos module
  # imports = [niri-flake.homeModules.niri];

  options.modules.wayland-shell.niri = {
    enable = mkEnableOption "Enable niri, the scrolling wayland window manager";
  };
  options.programs.niri = mkIf pkgs.stdenv.hostPlatform.isDarwin {
    config = mkOption {
      type = types.str;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    modules.core.gui = {
      enable = mkForce true;
      wmType = "wayland";
      wmName = "niri";
    };

    modules.wayland-shell.utils.enable = mkForce true;

    programs.niri = {
      # enable = true;
      config = readFile ./config.kdl;
    };
    assertions = [
      {
        assertion = pkgs.system == "aarch64-linux" || pkgs.system == "x86_64-linux";
        message = "Only supported in linux systems";
      }
    ];
  };
}
