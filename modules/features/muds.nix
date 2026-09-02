{inputs, ...}: {
  flake.modules.homeManager.muds = {
    pkgs,
    config,
    lib,
    ...
  }: {
    home.packages = with pkgs; [
      # mudlet-custom
      mudforge-appimage
      rune-mud
    ] ++ lib.optionals config.modules.core.gui.enable [
      # GUI-only; only install where a graphical session exists
      smudgy
    ];
  };
}
