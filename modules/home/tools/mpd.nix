{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.tools.mpd;
in {
  imports = [];

  options = {
    modules.tools.mpd = {
      enable = mkOption {
        description = "Enable mpd music daemon service, enabling does nothing on MacOS";
        default = false;
        type = types.bool;
      };
      mpdris2.enable = lib.mkEnableOption "Enable mpdris2 integration";
      mpd-discord-rpc.enable = lib.mkEnableOption "Enable mpd-discord-rpc integration";
    };
  };

  config = mkIf (cfg.enable
    && pkgs.stdenv.isLinux) {
    home.packages = with pkgs; [
      mpc-cli
      playerctl
    ];
    services.mpd = {
      enable = true;
      musicDirectory = "${config.home.homeDirectory}/music";

      # allow remote control of mpd
      network = {
        listenAddress = "any";
        port = 6600;
        startWhenNeeded = true;
      };

      extraConfig = ''
        # visualizer
        audio_output {
          type      "fifo"
          name      "my_fifo"
          path      "/tmp/mpd.fifo"
          format    "44100:16:2"
        }

        # output to pulse on linux
        audio_output {
          type      "pulse"
          name      "my pulse output"
        }
      '';
    };

    # tui for mpd
    programs.ncmpcpp = {
      enable = true;
      package = pkgs.ncmpcpp.override {
        outputsSupport = true;
        visualizerSupport = true;
        clockSupport = true;
        taglibSupport = true;
      };
      settings = {
        visualizer_data_source = "/tmp/mpd.fifo";
        visualizer_output_name = "my_fifo";
        visualizer_in_stereo = "yes";
        visualizer_type = "spectrum";
        visualizer_look = "+|";
      };
    };

    # mpris2 support for mpd
    services.mpdris2 = {
      enable = cfg.mpdris2.enable;
      notifications = true;
      mpd = {
        host = "localhost";
        port = 6600;
      };
    };

    # show current playing in discord
    services.mpd-discord-rpc.enable = cfg.mpd-discord-rpc.enable;
    services.mpd-discord-rpc.settings = {
      id = 1084861522888642661;
      format = {
        large_image = "suisei";
        small_image = "suisei3";
        large_text = "Sui-chan wa, kyou mo kawaii!!";
        small_text = "Hoshiyomi gang";
      };
    };

    services.playerctld.enable = true;
  };
}
