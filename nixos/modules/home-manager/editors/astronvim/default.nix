{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.editors.astronvim;
in {
  options.modules.editors.astronvim = {
    enable = mkOption {
      default = true;
      description = "Enable AstroNvim";
      type = types.bool;
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
      python3
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
      # we avoid using the wrapped neovim thing
    };
  };
}