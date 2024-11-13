{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.editors.lazyvim;
in {
  options.modules.editors.lazyvim = {
    enable = mkOption {
      default = true;
      description = "Enable LazyVim";
      type = types.bool;
    };
    setDefault = mkOption {
      default = false;
      description = "Make this your default EDITOR";
    };
  };

  config = mkIf cfg.enable {
    home.file = {
      ".config/nvim" = {
        recursive = true;
        source = ./config;
      };
    };

    home.packages = with pkgs;
    with lua51Packages; [
      # lua packages
      luacheck
      jsregexp
      luarocks

      # nixos packages
      luajit

      ripgrep
      nodejs
      cargo
      unzip
      lazygit
      gnumake

      # language servers
      lua-language-server
      nil

      # formatters
      alejandra
      shfmt
      stylua

      # diagnostics
      statix
      deadnix
      selene
    ];

    programs.neovim = {
      enable = true;
      defaultEditor = cfg.setDefault;
    };
  };
}
