{ lib
, fetchFromGitHub
, pkgs
, stdenv
, mkTmuxPlugin
}:

rec {
  catppuccin = mkTmuxPlugin {
    pluginName = "catppuccin";
    version = "1.0.0";
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "tmux";
      rev = "e2561decc2a4e77a0f8b7c05caf8d4f2af9714b3";
    };
    rtpFilePath = "catppuccin.tmux";
  };
}
