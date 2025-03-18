{
  imports = [
    ./configopts.nix

    ./browsers
    ./editors
    ./games
    ./prod
    ./sound
    ./terminals
    ./tools
    ./wayland-shell
  ];
  home.stateVersion = "22.11";
}
