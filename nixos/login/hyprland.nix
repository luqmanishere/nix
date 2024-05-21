{
  flake,
  pkgs,
  ...
}: let
  inherit (flake) inputs;
in {
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };
}
