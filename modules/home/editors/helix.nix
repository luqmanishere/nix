{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.editors.helix;
in {
  options.modules.editors.helix = {enable = mkEnableOption "Enable helix";};

  config = mkIf cfg.enable {
    programs.helix = {
      enable = true;
      extraPackages = with pkgs;
        []
        ++ (
          if pkgs.system != "aarch64-darwin"
          then [kdePackages.qtdeclarative]
          else []
        );
      settings = {
        theme = "catppuccin_mocha";
        editor = {
          line-number = "relative";
          cursorline = true;
          bufferline = "multiple";
          color-modes = true;
          popup-border = "all";
          end-of-line-diagnostics = "hint";

          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };

          lsp = {
            enable = true;
            display-messages = true;
            display-progress-messages = true;
            auto-signature-help = true;
            display-inlay-hints = true;
            snippets = true;
          };

          auto-save = {
            focus-lost = true;
            after-delay = {
              enable = true;
              timeout = 3000;
            };
          };

          indent-guides.render = true;

          inline-diagnostics = {
            cursor-line = "warning";
            other-lines = "error";
          };
        };

        keys = {
          normal = {
            H = ":bp";
            L = ":bn";
          };
          insert = {
            k.j = "normal_mode";
          };
        };
      };

      # refer https://github.com/helix-editor/helix/blob/master/languages.toml
      languages = {
        # for individual language conf
        language = [
          {
            name = "nix";
            auto-format = true;
            formatter = {
              command = "${getExe pkgs.alejandra}";
              args = ["-"];
            };
          }
          {
            name = "qml";
            auto-format = true;
          }
          {
            name = "toml";
            language-servers = ["tombi" "taplo"];
            auto-format = true;
          }
        ];

        # this is for language server configuration
        language-server = with pkgs; {
          # rust
          rust-analyzer = {
            command = "${getExe rust-analyzer}";
            config.cargo = {
              targetDir = true;
            };
          };

          # nix
          nixd = {
            command = "${getExe nixd}";
          };

          # markdown
          marksman = {
            command = "${getExe marksman}";
          };

          # qml
          qmlls = {
            args = ["-E"];
            command = "qmlls";
          };

          tombi = {
            command = "${getExe tombi}";
            args = ["lsp"];
          };
        };
      };
    };
  };
}
