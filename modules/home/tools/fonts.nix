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

  # this is default, because fonts are used everywhere.
  # No harm in installing them.
  options.modules.tools.fonts.enable = mkOption {
    default = true;
    description = "enable fonts";
    type = types.bool;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      jetbrains-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.noto
      nerd-fonts.symbols-only
      material-symbols
      # TODO: fix packages
      # self.packages.${pkgs.system}.iosevka-solemnattic

      maple-mono.NF

      fontconfig
    ];

    fonts.fontconfig.enable = true;
  };
}
