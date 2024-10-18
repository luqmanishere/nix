{
  self,
  inputs,
  config,
  ...
}: {
  flake = {
    darwinModules = {
      default.imports = [
        self.darwinModules_.home-manager
        self.nixosModules.common
        ./environment.nix
        ./users.nix
        ./touch-id.nix
        ./nh-darwin.nix
        ./homebrew.nix
        # ./desktop/yabai
        # ./desktop/sketchybar
      ];
    };
  };
}
