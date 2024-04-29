{self, ...}: let
  # create entry for a system
  mkSystem = {
    # hostname of the system
    hostname ? "nixos",
    # additional nixos modules (applied after common modules)
    nixosModules ? [],
    # additonal home manager modules (applied after default hostname specific module)
    homeManagerModules ? [],
    # extra config applied after all modules
    extraConfig ? {},
  }: {
    imports = [self.nixosModules.common] ++ nixosModules ++ [extraConfig];

    home-manager.users.luqman = {
      imports = [self.homeModules."luqman-${hostname}"] ++ homeManagerModules;
    };
  };
in {
  flake = {
    # declare our modules here
    nixosModules = {
      # common modules that should be present on all systems
      common = {
        imports = [
          ./nix.nix
          self.nixosModules.home-manager

          ./users.nix
          ./groups.nix
          ./dev.nix
          ./shells.nix
        ];

        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      };

      ###### system specific configurations

      # main laptop configuration
      asuna = mkSystem {
        hostname = "asuna";
        nixosModules = [./steam.nix];
      };

      # wsl2 config
      sinon = mkSystem {
        hostname = "sinon";
        nixosModules = [./wsl.nix];
      };
    };
  };
}
