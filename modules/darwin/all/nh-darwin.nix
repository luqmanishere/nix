{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) nh-darwin;
in {
  # temporary disable
  # imports = [nh-darwin.nixDarwinModules.prebuiltin];

  config = {
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 1d --keep 3 --nogcroots";
      };
      # flake = "/Users/luqman/nix";
    };
  };
}
