{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  # Enable home-manager for "luqman" user
  home-manager.users."luqman" = {
    imports = [
      (self + /configurations/home/luqman.nix)
      self.homeModules.default
    ];

    modules.core.gui.enable = true;

    modules.browsers.zen.enable = true;

    modules.editors.neovide.enable = true;

    modules.productivity = {
      comms.enable = true;
      essentials.enable = true;
    };

    modules.terminals = {
      zellij.enable = true;
      kitty = {
        enable = true;
        fontSize = 12.0;
        mapleFont = true;
      };
    };

    modules.tools = {
      fonts.enable = true;
      mpd = {
        enable = true;
        mpdris2.enable = true;
      };
    };

    modules.wayland-shell = {
      niri.enable = true;

      anyrun.enable = true;
      dunst.enable = true;
      wayper.enable = true;
    };
  };
}
