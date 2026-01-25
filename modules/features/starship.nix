{...}: {
  flake.modules.homeManager.shell = {
    lib,
    config,
    ...
  }:
    with lib; {
      programs.starship = mkMerge [
        {
          enable = true;
          enableTransience = true;
          settings = {
            add_newline = true;
            continuation_prompt = "▶▶ ";
            format = concatStrings [
              "[╭─](white)$username$hostname$directory$nix_shell$package$java$python$git_branch$git_state$git_status$\{custom.jj\}$battery$cmd_duration$time$line_break"
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

            custom.jj = {
              command = "jj log -r @ --no-pager --no-graph --color never --template 'self.change_id().shortest()'";
              detect_folders = [".jj"];
              format = "jj on [$output]($style) ";
            };
          };
        }
        (mkIf config.programs.fish.enable {
          enableFishIntegration = true;
        })
      ];
    };
}
