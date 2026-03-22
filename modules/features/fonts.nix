{...}: {
  flake.modules.homeManager.fonts = {pkgs, ...}: {
    home.packages = with pkgs; [
      # fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
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
      maple-mono.Normal-NF

      fontconfig
    ];

    fonts.fontconfig.enable = true;
  };
}
