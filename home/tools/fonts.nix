{
  flake,
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  inherit (flake) self;
  cfg = config.modules.tools.fonts;
in {
  imports = [];

  options.modules.tools.fonts.enable = mkOption {
    default = true;
    description = "enable fonts";
    type = types.bool;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      jetbrains-mono
      (nerdfonts.override {fonts = ["JetBrainsMono" "FiraCode" "Noto" "NerdFontsSymbolsOnly"];})
      self.packages.${pkgs.system}.iosevka-solemnattic
      self.packages.${pkgs.system}.maple-mono-NF-beta

      fontconfig
    ];

    fonts.fontconfig.enable = true;
  };
}
