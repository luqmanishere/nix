# this module was adapted from hlissner, the creator of Doom Emacs

{ config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.modules.editors.emacs;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.editors.emacs = {
    enable = mkOption {
      description = "enable emacs config";
      default = false;
      type = types.bool;
    };
    doom = rec {
      enable = mkOption {
        description = "Enable doom-emacs";
        default = false;
        type = types.bool;
      };
      repoUrl = mkOption {
        description = "doom repo url";
        type = types.str;
        default = "https://github.com/doomemacs/doomemacs";
      };
      doomConfigFiles = mkOption {
        description = "path to doom config files";
        type = types.nullOr types.path;
        default = null;
      };
    };
  };

  config = mkIf cfg.enable {
    /* nixpkgs.overlays = [ inputs.emacs-overlay.overlay ]; */

    home.packages = with pkgs; [
      ## Emacs itself
      binutils # native-comp needs 'as', provided by this
      # 28.2 + native-comp

      emacs
      ## Doom dependencies
      git
      (ripgrep.override { withPCRE2 = true; })
      gnutls # for TLS connectivity

      ## Optional dependencies
      fd # faster projectile indexing
      imagemagick # for image-dired
      /* (mkIf (config.programs.gnupg.agent.enable) */
      /*   pinentry_emacs) # in-emacs gnupg prompts */
      zstd # for undo-fu-session/undo-tree compression

      ## Module dependencies
      # :checkers spell
      (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
      # :tools editorconfig
      editorconfig-core-c # per-project style config
      # :tools lookup & :lang org +roam
      sqlite
      # :lang latex & :lang org (latex previews)
      texlive.combined.scheme-medium
      # :lang beancount
      beancount
      #fava # HACK Momentarily broken on nixos-unstable

      emacs-all-the-icons-fonts
    ];

    #env.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];
    home.sessionPath = [ "$XDG_CONFIG_HOME/emacs/bin" ];

    # modules.shell.zsh.rcFiles = [ "${configDir}/emacs/aliases.zsh" ];

    #fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];

    home.activation = mkIf cfg.doom.enable {
      installDoomEmacs = ''
        if [ ! -d "$XDG_CONFIG_HOME/emacs" ]; then
           ${pkgs.git}/bin/git clone --depth=1 --single-branch "${cfg.doom.repoUrl}" "$XDG_CONFIG_HOME/emacs"
        fi
      '';
    };
    xdg.configFile."doom".source = cfg.doom.doomConfigFiles;
  };
}
