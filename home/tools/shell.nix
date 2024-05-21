{pkgs, ...}: {
  # TODO: split up into smaller files
  imports = [];

  config = {
    home.packages = with pkgs; [
      age
    ];
    programs = {
      starship = {
        enable = true;
        enableFishIntegration = true;
      };

      fzf = {
        enable = true;
        enableFishIntegration = true;
        defaultOptions = [
          "--preview 'bat --color=always {}'"
        ];
      };

      fish = {
        enable = true;
        shellAliases = {
          ls = "eza --git --group-directories-first --time-style=long-iso";
          l = "ls -1";
          sl = "ls";
          ll = "ls -al";
          la = "ls -lbhHigUmuSa";
          tree = "eza --tree";

          ip = "ip --color=auto";

          tm = "tmux attach -t main || tmux new -s main";

          nvimdev = "NVIM_APPNAME=\"nvimdev\" nvim";
        };
        shellAbbrs = {
          psg = "ps ax | grep -i";
        };
        shellInit = ''
          set -U fish_greeting "Welcome SolemnAttic. System initialized."
        '';
        interactiveShellInit = ''
          set -U XDG_DATA_DIRS $XDG_DATA_DIRS /var/lib/flatpak/exports/share /home/luqman/.local/share/flatpak/exports/share
        '';

        plugins = [
          {
            name = "done";
            src = pkgs.fetchFromGitHub {
              owner = "franciscolourenco";
              repo = "done";
              rev = "eb32ade85c0f2c68cbfcff3036756bbf27a4f366";
              hash = "sha256-DMIRKRAVOn7YEnuAtz4hIxrU93ULxNoQhW6juxCoh4o=";
            };
          }
          {
            name = "fish-abbreviation-tips";
            src = pkgs.fetchFromGitHub {
              owner = "Gazorby";
              repo = "fish-abbreviation-tips";
              rev = "8ed76a62bb044ba4ad8e3e6832640178880df485";
              hash = "sha256-F1t81VliD+v6WEWqj1c1ehFBXzqLyumx5vV46s/FZRU=";
            };
          }
        ];
      };

      bash.enable = true;

      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };

      git = {
        enable = true;
        userName = "luqmanishere";
        userEmail = "luqmanulhakim1720@gmail.com";
        extraConfig = let
          deltaCommand = "${pkgs.delta}/bin/delta";
        in {
          core = {
            pager = "${deltaCommand} --diff-so-fancy";
          };
          delta = {
            navigate = true;
            light = false;
            side-by-side = true;
          };
          merge = {
            conflictstyle = "diff3";
          };
          diff = {
            colorMoved = "default";
          };
          interactive = {
            diffFilter = "${deltaCommand} --color-only";
          };
        };
      };

      helix = {
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

      eza = {
        enable = true;
      };

      zoxide = {
        enable = true;
        enableFishIntegration = true;
      };

      bat = {
        enable = true;
        themes = {
          Catppuccin-mocha = {
            src =
              pkgs.fetchFromGitHub
              {
                owner = "catppuccin";
                repo = "bat";
                rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
                sha256 = "6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
              };
            file = "Catppuccin-mocha.tmTheme";
          };
        };
        config = {
          theme = "Catppuccin-mocha";
        };
      };

      tmux = {
        enable = true;
        baseIndex = 1;
        clock24 = true;
        historyLimit = 10000;
        #mouse = true;
        sensibleOnTop = true;
        prefix = "`";
        mouse = true;
        plugins = with pkgs.tmuxPlugins; [
          yank
          {
            plugin = dracula;
            extraConfig = ''
              set -g @dracula-plugins "battery cpu-usage ram-usage network time"
              set -g @dracula-show-powerline true
              set -g @dracula-show-flags true
              set -g @dracula-military-time true
              set -g @dracula-show-left-icon session
            '';
          }
          sensible
          resurrect
          continuum
          fzf-tmux-url
          extrakto
          better-mouse-mode
          (mkTmuxPlugin {
            pluginName = "tmux-session-wizard";
            version = "unstable-2021-06-20";
            src = pkgs.fetchFromGitHub {
              owner = "27medkamal";
              repo = "tmux-session-wizard";
              rev = "1b547d2b8e6435c3b825e8e7616911d74ea6ec4d";
              sha256 = "4EquWiR8ercuhC/+qNUQQn8WfrjZiDCU0Z3/yeHJlBA=";
            };
            rtpFilePath = "session-wizard.tmux";
          })
        ];
        extraConfig = ''
          set -g default-terminal "tmux-256color"
          set -ag terminal-overrides ",xterm-256color:RGB"
          bind a last-window

          # Switch panes with hjkl
          bind -r h select-pane -L
          bind -r j select-pane -D
          bind -r k select-pane -U
          bind -r l select-pane -R

          # resize panes
          bind -r H resize-pane -L 5
          bind -r J resize-pane -D 5
          bind -r K resize-pane -U 5
          bind -r L resize-pane -R 5

          # split panes using | and -
          bind | split-window -h
          bind - split-window -v
          unbind '"'
          unbind %

          # switch panes using Alt-arrow without prefix
          bind -n M-Left select-pane -L
          bind -n M-Right select-pane -R
          bind -n M-Up select-pane -U
          bind -n M-Down select-pane -D

          ## Quickly switch panes
          unbind ^J
          bind ^J select-pane -t :.+

          bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded"

          set -g allow-passthrough on
        '';
      };

      keychain = {
        enable = true;
        enableZshIntegration = true;
        enableFishIntegration = true;
        inheritType = "any";
        agents = ["gpg" "ssh"];
        keys = ["gitmain" "general"];
      };

      neovim = {
        enable = true;
        defaultEditor = true;
      };

      bottom.enable = true;

      htop.enable = true;
    };
  };
}
