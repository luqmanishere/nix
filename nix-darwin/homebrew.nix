{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) nix-homebrew;
in {
  imports = [nix-homebrew.darwinModules.nix-homebrew];

  config = {
    nix-homebrew = {
      # Install Homebrew under the default prefix
      enable = true;

      # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
      enableRosetta = true;

      # User owning the Homebrew prefix
      user = "luqman";

      # Automatically migrate existing Homebrew installations
      autoMigrate = true;
    };
  };
}
