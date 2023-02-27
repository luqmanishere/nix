{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default
    ./nvim/nvchad-nvim.nix
    ./graphical.nix
    #./kitty.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.modifications
      outputs.overlays.additions

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
    # FIXME: seperate cli, desktop profiles
    fzf
    ripgrep
    fd
    bat
    helix
    keychain
    tmux
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
    enableAliases = true;
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
    plugins = with pkgs.tmuxPlugins; [
      yank
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-plugins "battery cpu-usage ram-usage network time"
          set -g @dracula-show-powerline true
          set -g @dracula-show-flags true
          set -g @dracula-military-time true
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
  };
  nvchad.enable = true;
  nvchad.userConfig = ./nvim/nvchad-conf;

  graphical.enable = true;
  kitty-conf.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
