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
      inputs.blightmud.packages.${pkgs.stdenv.hostPlatform.system}.blightmud-tts
      rune-mud
    ] ++ lib.optionals config.modules.core.gui.enable [
      # GUI-only; only install where a graphical session exists
      smudgy
    ];
  };
}
