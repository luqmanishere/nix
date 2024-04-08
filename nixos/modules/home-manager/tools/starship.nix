{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.tools.starship;
in {
  imports = [];

  options.modules.tools.starship.enable = mkOption {
    default = true;
    description = "enable the starship prompt";
    type = types.bool;
  };

  config = mkIf (cfg.enable) {
    programs.starship = mkMerge [
      {
        enable = true;
        enableTransience = true;
        settings = {
          add_newline = true;
          continuation_prompt = "▶▶ ";
          format = concatStrings [
            "[╭─](white) $username$hostname$directory$package$java$python$git_branch$battery$cmd_duration $line_break"
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
            format = "[$time]($style) ";
          };
          username = {
            show_always = true;
            format = "[$user]($style)@";
          };
          hostname = {
            ssh_only = false;
          };
        };
      }
      (mkIf (config.programs.fish.enable) {
        enableFishIntegration = true;
      })
    ];
  };
}
