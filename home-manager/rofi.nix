{ inputs, pkgs, lib, config, ... }:
with lib; let
  cfg = config.rofi;
  catppuccin = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "rofi";
    rev = "5350da41a11814f950c3354f090b90d4674a95ce";
    sha256 = "DNorfyl3C4RBclF2KDgwvQQwixpTwSRu7fIvihPN8JY=";
  } + "/deathemonic";
in
{
  imports = [ ];

  options.rofi = {
    enable = mkOption {
      default = false;
      description = "Enable rofi configuration";
      type = types.bool;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = [
      pkgs.rofi-wayland
    ];
    # programs.rofi = {
    #   enable = true;
    #   package = pkgs.rofi-wayland;
    #   #terminal = "\${pkgs.kitty}/bin/kitty";
    # };
    xdg.configFile."rofi".source = catppuccin;
  };
}
