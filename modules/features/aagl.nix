{inputs, ...}: {
  flake.modules.nixos.aagl = {...}: let
    inherit (inputs) aagl;
  in {
    imports = [aagl.nixosModules.default];
    config = {
      programs.anime-game-launcher.enable = true;
      # programs.honkers-railway-launcher.enable = true;
    };
  };
}
