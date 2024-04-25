{
  description = "Luqman's Nix Config done right";

  outputs = inputs @ {
    self,
    flake-parts,
    flake-root,
    home-manager,
    nixpkgs,
    treefmt-nix,
    devenv,
    nixos-flake,
    ...
  }: let
    # Use our custom lib enhanced with nixpkgs and home-manager
    lib = import ./nix/lib {inherit (nixpkgs) lib;} // nixpkgs.lib // home-manager.lib;
  in
    flake-parts.lib.mkFlake {
      inherit inputs;
      specialArgs = {inherit lib;};
    } {
      debug = true;
      imports = [
        flake-root.flakeModule
        nixos-flake.flakeModule
        treefmt-nix.flakeModule
        devenv.flakeModule
        ./nix
        ./nixos
        ./home
      ];

      systems = [
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      flake = {
        #main laptop
        nixosConfigurations.asuna = self.nixos-flake.lib.mkLinuxSystem ./systems/asuna;

        # configuration for WSL
        nixosConfigurations.sinon = self.nixos-flake.lib.mkLinuxSystem ./systems/sinon.nix;
      };

      _module.args._inputs = inputs // {inherit self;};

      perSystem = {
        pkgs,
        system,
        ...
      }: {
        # make pkgs available to all `perSystem` functions
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.neovim-nightly-overlay.overlay
          ];
        };

        # make custom lib available to all `perSystem` functions
        _module.args.lib = lib;

        packages = import ./pkgs {inherit pkgs;};
      };
    };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nix-conf.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-conf.cachix.org-1:ckJrXG+dLoz1zMLNce35EDFGlWcigKdrDlqdmv9kPbE="
    ];
  };

  # TODO: sort the damn inputs
  inputs = {
    # packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nix darwin when we need it only

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
    nixos-flake.url = "github:srid/nixos-flake";

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
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
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

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-flake = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv.url = "github:cachix/devenv";
    # to remove warnings on nix flake check
    nix2container.url = "github:nlewo/nix2container";
    nix2container.inputs = {nixpkgs.follows = "nixpkgs";};
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
  };
}
