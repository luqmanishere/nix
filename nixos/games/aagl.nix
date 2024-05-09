{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) aagl;
in {
  imports = [aagl.nixosModules.default];
  config = {
    programs.anime-game-launcher.enable = true;
    programs.honkers-railway-launcher.enable = true;
  };
}
