{
  self,
  config,
  ...
}: {
  flake = {
    # declare our modules here
    nixosModules = {
      # common modules that should be present on all systems
      common.imports = [
        ./nix.nix
        self.nixosModules.home-manager

        ./users.nix
        ./groups.nix
        ./dev.nix
        ./shells.nix
      ];
      common = {
      home-manager.useGlobalPkgs  = true;
      home-manager.useUserPackages = true;
      };

      # system specific configurations

      # main laptop configuration
      asuna = {
        imports = [
          self.nixosModules.common
          ./steam.nix
        ];

# never forget to import important things
        home-manager.users.luqman = {
          imports = [self.homeModules.luqman-asuna];
        };
      };

      # wsl setup
      sinon = {
        imports = [
          self.nixosModules.common
          ./wsl.nix
        ];
        home-manager.users.luqman = {
          imports = [self.homeModules.luqman-sinon];
        };
      };
    };
  };
}
