{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.tools.fonts;
in {
  imports = [];

  options.modules.tools.fonts.enable = mkEnableOption "enable fonts";

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      # fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      jetbrains-mono
      (nerdfonts.override {fonts = ["JetBrainsMono" "FiraCode" "Noto"];})
      self.packages.${pkgs.system}.iosevka-solemnattic

      fontconfig
    ];

    fonts.fontconfig.enable = true;
  };
}
