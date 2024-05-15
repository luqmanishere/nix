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
      package = pkgs.neovim-nightly;
      # package = inputs.neovim-flake.packages.${pkgs.system}.neovim;
      # we avoid using the wrapped neovim thing
    };
  };
}
