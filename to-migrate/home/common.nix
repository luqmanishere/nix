{
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ./configopts.nix

    ./browsers
    ./editors
    ./games
    ./prod
    ./secrets
    ./sound
    ./terminals
    ./tools
  ];

  home.stateVersion = "22.11";
}
