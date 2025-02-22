# shared by MacOS & Linux
{
  flake,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (flake) inputs;
in {
  home.stateVersion = "22.11";
  imports = [
    # editor
    ./all/editors/nvim-nixcats.nix
    ./all/tools/shell.nix
    ./all/tools/starship.nix
    ./all/terminals/zellij.nix
    # ./all/tools/mpd.nix
    # ./all/tools/task.nix
    # ./all/secrets
    # ./all/tools/python.nix
  ];
  modules.editors.nixCats.setDefault = lib.mkDefault true;

  # from luqman-home.nix
  home = {
    # FIXME: this is a temp fix
    packages = [
      inputs.nvim-nixcats.packages.${pkgs.system}.nixCats
    ];
    sessionVariables = {
      COLORTERM = "truecolor";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      MEOW = "cat";
    };
  };
}
