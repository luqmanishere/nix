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
      ];
    };
  };
}
