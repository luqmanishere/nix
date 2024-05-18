{
  flake,
  lib,
  pkgs,
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
in {
  imports = [inputs.ags.homeManagerModules.default];

  config = {
    programs.ags = {
      enable = true;
      # TODO: integrate ags-config
      # configDir = ./ags-config;
    };
    home.packages = with pkgs; [bun sassc ags-devscript];
  };
}
