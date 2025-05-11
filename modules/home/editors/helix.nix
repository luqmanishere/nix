{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.editors.helix;
in {
  options.modules.editors.helix = {enable = mkEnableOption "Enable helix";};

  config = mkIf cfg.enable {
    programs.helix = {
      enable = true;
      settings = {
        theme = "catppuccin_mocha";
        editor = {
          line-number = "relative";
          cursorline = true;
          bufferline = "multiple";
          color-modes = true;
          popup-border = "all";
          end-of-line-diagnostics = "hint";

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
          insert = {
            k.j = "normal_mode";
          };
        };
      };
    };
  };
}
