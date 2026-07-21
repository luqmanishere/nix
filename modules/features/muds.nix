{inputs, ...}: {
  flake.modules.homeManager.muds = {pkgs, ...}: {
    home.packages = with pkgs; [
      mudlet
      mudforge-appimage
      inputs.blightmud.packages.${pkgs.stdenv.hostPlatform.system}.blightmud-tts
      rune-mud
    ];
  };
}
