{
  flake,
  lib,
  pkgs,
  ...
}:
with lib; let
  inherit (flake) inputs;
in {
  imports = [inputs.ags.homeManagerModules.default];

  config = {
    programs.ags = {
      enable = true;
      # TODO: integrate ags-config
      # configDir = ./ags-config;
    };
    home.packages = with pkgs; [bun sassc];
  };
}
