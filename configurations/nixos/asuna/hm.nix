{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  # Enable home-manager for "runner" user
  home-manager.users."runner" = {
    imports = [(self + /configurations/home/runner.nix)];
  };
}
