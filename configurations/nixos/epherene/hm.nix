{
  flake,
  pkgs,
  ...
}: let
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

    # TODO: put in module
    home.packages = with pkgs; [
      moonlight-qt
      prismlauncher
      chromium
    ];

    modules.core.gui.enable = true;

    modules.browsers.firefox.enable = true;
    modules.browsers.zen.enable = true;

    modules.editors = {
      cursor.enable = true;
      emacs.enable = true;
      helix.enable = true;
      neovide.enable = true;
      vscode.enable = true;
      zed.enable = true;
    };

    modules.productivity = {
      comms.enable = true;
      essentials.enable = true;
    };

    modules.secrets = {
      enable = true;
      taskd.enable = true;
    };

    modules.terminals = {
      zellij.enable = true;
      kitty = {
        enable = true;
        fontSize = 11.0;
        mapleFont = true;
      };
    };

    modules.tools = {
      claudecode.enable = true;
      fonts.enable = true;
      mpd = {
        enable = true;
        mpdris2.enable = true;
      };
      obsidian.enable = true;
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
      # use quickshell's notification
      dunst.enable = false;

      sherlock.enable = true;
      waybar = {
        enable = false;
        width = 1700;
      };
      quickshell.enable = true;
      wayper.enable = true;
    };
  };
}
