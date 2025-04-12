{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  # Enable home-manager for "luqman" user
  home-manager.users."luqman" = {
    imports = [
      (self + /configurations/home/luqman.nix)
      self.homeModules.common
      self.homeModules.linux-only
    ];

    modules.core.gui.enable = true;

    modules.browsers.zen.enable = true;

    modules.editors = {
      neovide.enable = true;
      vscode.enable = true;
      zed.enable = true;
    };

    modules.productivity = {
      comms.enable = true;
      essentials.enable = true;
    };

    modules.secrets.enable = true;

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
      taskwarrior.enable = true;
    };
    modules.solemnattic.tools.syncthing.enable = true;

    modules.wayland-shell = {
      niri.enable = true;

      anyrun.enable = true;
      hypridle = {
        enable = true;
        keyboardLed = {enable = true;};
      };
      hyprlock.enable = true;
      dunst.enable = true;
      waybar = {
        enable = true;
        width = 1400;
      };
      wayper.enable = true;
    };
  };
}
