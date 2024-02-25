{
  description = "solemnattic's nix config";

  inputs = {
    # Nixpkgs unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland = {
      url = "github:hyprwm/Hyprland/v0.35.0";
      inputs.nixpkgs.follows = "nixpkgs"; # MESA/OpenGL HW workaround
    };
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
    xremap-flake.url = "github:xremap/nix-flake";
    ags.url = "github:Aylur/ags";

    homeage.url = "github:jordanisaacs/homeage";
    homeage.inputs.nixpkgs.follows = "nixpkgs";

    wayper.url = "github:luqmanishere/wayper";

    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    emacs-overlay.url = "github:nix-community/emacs-overlay";

    devenv.url = "github:cachix/devenv";
    nil.url = "github:oxalica/nil";
    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    prismlauncher.url = "github:PrismLauncher/PrismLauncher";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    # hardware.url = "github:nixos/nixos-hardware";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    devenv,
    ...
  } @ inputs: let
    inherit (self) outputs;
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  in {
    # Your custom packages
    # Acessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      import ./pkgs {inherit pkgs;});
    # Devshell for bootstrapping
    # Acessible through 'nix develop' or 'nix-shell' (legacy)
    devShells =
      forAllSystems
      (
        system: let
          pkgs = nixpkgs.legacyPackages.${system};
        in {
          default =
            devenv.lib.mkShell
            {
              inherit inputs pkgs;
              modules = [
                ({pkgs, ...}: {
                  packages = with pkgs; [
                    hello
                    inputs.home-manager.packages.${system}.default
                    git
                    neovim
                    curl
                    wget
                    aria2
                  ];
                  enterShell = ''
                    hello
                  '';

                  processes.run.exec = "hello";
                })
              ];
            };
        }
      );

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixos-vm = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          # > Our main nixos configuration file <
          ./nixos/nixos-vm.nix
        ];
      };
      asuna = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          self.nixosModules.cloudflare-warp
          #nixosModules.systemd-secure-boot
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.impermanence.nixosModules.impermanence
          # inputs.hyprland.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          ./nixos/asuna.nix
          {
            home-manager = {
              useUserPackages = true;
              # useGlobalPkgs = true;
              extraSpecialArgs = {inherit inputs outputs;};
              users.luqman = ./home-manager/luqman-desktop.nix;
            };
          }
        ];
      };
      sinon = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          inputs.home-manager.nixosModules.home-manager
          ./nixos/sinon.nix

          {
            home-manager = {
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs outputs;};
              users.luqman = ./home-manager/luqman-sinon.nix;
            };
          }
        ];
      };
      kurumi = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          inputs.home-manager.nixosModules.home-manager
          ./nixos/kurumi.nix

          {
            home-manager = {
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs outputs;};
              users.luqman = ./home-manager/luqman-kurumi.nix;
            };
          }
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "luqman@nixos-vm" = home-manager.lib.homeManagerConfiguration {
        pkgs =
          nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/luqman-desktop.nix
        ];
      };
      "luqman@asuna" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        #nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/luqman-desktop.nix
        ];
      };
      "luqman@sinon" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home-manager/luqman-sinon.nix];
      };
    };
  };
}
