{ config, lib, pkgs, inputs, ... }:
with lib;
let cfg = config.mpd; in {
  imports = [ ];

  options = {
    mpd = {
      enable = mkOption {
        description = "Enable mpd music daemon service";
        default = true;
        type = types.bool;
      };
    };
  };

  config = mkIf (cfg.enable) {
    services.mpd = {
      enable = true;
      musicDirectory = "~/Music/";
      extraConfig = ''
        audio_output {
          type      "fifo"
          name      "my_fifo"
          path      "/tmp/mpd.fifo"
          format    "44100:16:2"
        }
        
        audio_output {
          type      "pulse"
          name      "my pulse output"
        }
      '';
    };
    programs.ncmpcpp.enable = true;
  };

}
