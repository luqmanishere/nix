{
  description = "Luqman's Nix Config done right";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    # packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nil.url = "github:oxalica/nil";
    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap-flake.url = "github:xremap/nix-flake";

    # flake-parts
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    flake-root.url = "github:srid/flake-root";

    # utilities
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-registry = {
      url = "github:NixOS/flake-registry";
      flake = false;
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    hyprland = {
      url = "github:hyprwm/Hyprland/v0.37.1";
      inputs.nixpkgs.follows = "nixpkgs"; # MESA/OpenGL HW workaround
    };
    hypridle = {
      url = "github:hyprwm/hypridle/4395339a2dc410bcf49f3e24f9ed3024fdb25b0a";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock/2ae79757d5e5c48de2f4284992a6bfa265853a2d";
    };
    wayper.url = "github:luqmanishere/wayper";
    agenix.url = "github:ryantm/agenix";
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv";
    # to remove warnings on nix flake check
    nix2container.url = "github:nlewo/nix2container";
    nix2container.inputs = {nixpkgs.follows = "nixpkgs";};
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    flake-root,
    home-manager,
    nixpkgs,
    treefmt-nix,
    devenv,
    ...
  }: let
    # Use our custom lib enhanced with nixpkgs and home-manager
    lib = import ./nix/lib {lib = nixpkgs.lib;} // nixpkgs.lib // home-manager.lib;
  in
    flake-parts.lib.mkFlake {
      inherit inputs;
      specialArgs = {inherit lib;};
    } {
      debug = true;
      imports = [
        flake-root.flakeModule
        treefmt-nix.flakeModule
        devenv.flakeModule
        ./nix
        ./nixos
      ];

      systems = [
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      flake = {
        # overlays?
        overlays = {
          # channels = final: prev: {
          #   # expose other channels via overlays
          # };
        };
        homeManagerModules = import ./modules/home-manager;
      };

      _module.args._inputs = inputs // {inherit self;};

      perSystem = {
        inputs',
        pkgs,
        ...
      }: {
        # make pkgs available to all `perSystem` functions
        _module.args.pkgs = inputs'.nixpkgs.legacyPackages;
        # make custom lib available to all `perSystem` functions
        _module.args.lib = lib;

        packages = import ./pkgs {inherit pkgs;};
      };
    };
}
