{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default
    ./nvim/lazyvim-nvim.nix
    ./graphical.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.modifications
      outputs.overlays.additions
      inputs.hyprland.overlays.default

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "luqman";
    homeDirectory = "/home/luqman";
    sessionVariables = {
      COLORTERM = "truecolor";
    };
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    exa
    starship
    fish

    git
    delta
    age

    # FIXME: seperate cli, desktop profiles
    fzf
    ripgrep
    fd
    bat
    helix
    keychain
    tmux
    discord
  ];

  # home manager please manage yourself
  programs.home-manager.enable = true;

  programs.firefox = {
    enable = true;
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    defaultOptions = [
      "--preview 'bat --color=always {}'"
    ];
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "exa --git --group-directories-first --time-style=long-iso";
      l = "ls -1";
      sl = "ls";
      ll = "ls -al";
      la = "ls -lbhHigUmuSa";
      tree = "exa --tree";

      ip = "ip --color=auto";

      tm = "tmux attach -t main || tmux new -s main";

    };
    shellAbbrs = {
      psg = "ps ax | grep -i";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "luqmanishere";
    userEmail = "luqmanulhakim1720@gmail.com";
    extraConfig = let deltaCommand = "${pkgs.delta}/bin/delta"; in {
      core = {
        pager = "${deltaCommand} --diff-so-fancy";
      };
      delta = {
        navigate = true;
        light = false;
        side-by-side = true;
      };
      merge = {
        conflictstyle = "diff3";
      };
      diff = {
        colorMoved = "default";
      };
      interactive = {
        diffFilter = "${deltaCommand} --color-only";
      };
    };
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        cursorline = true;
        lsp.display-messages = true;
        indent-guides.render = true;
      };
    };
  };

  programs.exa = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.bat = {
    enable = true;
    themes = {
      Catppuccin-mocha = builtins.readFile (pkgs.fetchFromGitHub
        {
          owner = "catppuccin";
          repo = "bat";
          rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
          sha256 = "6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
        } + "/Catppuccin-mocha.tmTheme");
    };
    config = {
      theme = "Catppuccin-mocha";
    };
  };

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    historyLimit = 10000;
    #mouse = true;
    sensibleOnTop = true;
    prefix = "`";
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      yank
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-plugins "battery cpu-usage ram-usage network time"
          set -g @dracula-show-powerline true
          set -g @dracula-show-flags true
          set -g @dracula-military-time true
          set -g @dracula-show-left-icon session
        '';
      }
      sensible
      resurrect
      continuum
      fzf-tmux-url
      extrakto
      better-mouse-mode
    ];
    extraConfig = ''
      bind a last-window

      # Switch panes with hjkl
      bind -r h select-pane -L
      bind -r j select-pane -D
      bind -r k select-pane -U
      bind -r l select-pane -R

      # resize panes
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # split panes using | and -
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # switch panes using Alt-arrow without prefix
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      ## Quickly switch panes
      unbind ^J
      bind ^J select-pane -t :.+

      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded"
    '';
  };

  programs.keychain = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    inheritType = "any";
    agents = [ "gpg" "ssh" ];
    keys = [ "gitmain" ];
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  lazyvim.enable = true;

  graphical.enable = true;
  hyprland.enable = true;
  kitty-conf.enable = true;
  dunst.enable = true;
  rofi.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
