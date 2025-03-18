{
  flake,
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  inherit (flake) inputs;
  ags-devscript = pkgs.writeShellApplication {
    name = "ags-dev";
    runtimeInputs = with pkgs; [inotify-tools ags];
    text = ''
      WORKDIR="$HOME/.config/ags"
      PID=0
      echo "ags config dir is $WORKDIR"

      function _ags() {
        if [[ $PID -ne 0 ]]
          then
            echo "killing ags"
            set +o errexit
            kill $PID
          else
            echo "ags first start"
        fi

        echo "starting ags"
        ags --inspector &
        PID=$!
      }

      _ags

      inotifywait --quiet --monitor --event create,modify,delete --recursive "$WORKDIR" | while read -r FILE; do
        file_extension=''${FILE##*.}
        case $file_extension in
          js|ts|json|lockb)
        echo "ags JS reload"
            _ags
          ;;
        esac
      done
    '';
  };
  cfg = config.modules.wayland-shell.ags;
in {
  imports = [inputs.ags.homeManagerModules.default];

  options.modules.wayland-shell.ags = {enable = lib.mkEnableOption "Enable AGS based shell";};

  config = {
    programs.ags = mkIf cfg.enable {
      enable = true;
      # TODO: integrate ags-config
      # configDir = ./ags-config;
    };
    home.packages = with pkgs; [bun sassc ags-devscript];

    assertions = [
      {
        assertion = config.modules.core.gui.enable;
        message = "a graphical environment is required.";
      }
    ];
  };
}
