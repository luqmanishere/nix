{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.tools.starship;
in {
  imports = [];

  # since this is for the shell, it os default
  options.modules.tools.starship.enable = mkOption {
    default = true;
    description = "enable the starship prompt";
    type = types.bool;
  };

  config = mkIf cfg.enable {
    programs.starship = mkMerge [
      {
        enable = true;
        enableTransience = true;
        settings = {
          add_newline = true;
          continuation_prompt = "▶▶ ";
          format = concatStrings [
            "[╭─](white)$username$hostname$directory$nix_shell$package$java$python$git_branch$git_state$git_status$battery$cmd_duration$time$line_break"
            "[╰─](white) $shell$character "
          ];
          line_break = {
            disabled = false;
          };
          shell = {
            disabled = false;
            fish_indicator = "🐟";
          };
          os = {
            disabled = false;
          };
          time = {
            disabled = false;
            format = ''[\[$time\]]($style) '';
          };
          username = {
            show_always = true;
            format = "[$user]($style)@";
          };
          hostname = {
            ssh_only = false;
          };
          nix_shell = {
            disabled = false;
            format = ''via [$symbol$state (\($name\))]($style) '';
            symbol = "❄️";
          };
          git_status = {
            disabled = false;
          };
        };
      }
      (mkIf config.programs.fish.enable {
        enableFishIntegration = true;
      })
    ];
  };
}
