# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
	./AstroNvim.nix
	./nyoom.nix
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
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  # TODO: Set your username
  home = {
    username = "luqman";
    homeDirectory = "/home/luqman";
    sessionVariables = {
        COLORTERM = "truecolor";
    };
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [ exa starship fish fzf ripgrep fd bat helix keychain ];

  # home manager please manage yourself
  programs.home-manager.enable = true;

  programs.starship  = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
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

  programs.bat = {
    enable = true;
    themes = {
      Catppuccin-mocha = builtins.readFile (pkgs.fetchFromGitHub {
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

programs.keychain = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    inheritType = "any";
    agents = [ "gpg" "ssh" ];
    keys = [ "id_rsa" ];
  };
  
  programs.neovim = {
  	enable = true;
  };
  astronvim.enable = false;
  nyoom.enable = true;
  nyoom.userConfig = ./nyoom-conf;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
