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
      default = false;
      description = "Enable AstroNvim";
      type = types.bool;
    };
    userConfig = {
      enable = mkEnableOption "Manage user config";
      path = mkOption {
        default = ./config;
        description = "AstroNvim extra config";
        type = with types; path;
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home = {
        packages = with pkgs; [
          # telescope dep
          ripgrep

          nodejs
          python3
          cargo
          lua51Packages.jsregexp
          unzip

          lazygit

          # language servers
          nil

          # formatters
          alejandra
          shfmt
          stylua

          # diagnostics
          statix
          deadnix
        ];

        activation = {
          installAstroNvim = ''
               if [ ! -d "$HOME/.config/nvim" ]; then
               	${pkgs.git}/bin/git clone --depth=1 --single-branch "https://github.com/AstroNvim/AstroNvim" "$HOME/.config/nvim"
            fi
               	${pkgs.neovim}/bin/nvim --headless -c 'quitall'
          '';
        };
      };
    })

    (mkIf cfg.userConfig.enable {
      home.file = {
        ".config/astronvim/lua/user" = {
          recursive = true;
          source = cfg.userConfig.path;
        };
      };
    })
  ];
}
