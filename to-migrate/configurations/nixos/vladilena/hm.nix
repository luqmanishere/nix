{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  # Enable home-manager for "luqman" user
  home-manager.users."luqman" = {
    imports = [(self + /configurations/home/luqman.nix)];

    modules.terminals.zellij.enable = true;
    modules.editors.nixCats.setDefault = true;
    modules.editors.helix.enable = true;
    modules.tools.fonts.enable = false;
  };
}
