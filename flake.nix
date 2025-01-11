{
  description = "Luqman's Nix Config done right";

  outputs = inputs @ {
    self,
    # flake-parts,
    # flake-root,
    # home-manager,
    # nixpkgs,
    # treefmt-nix,
    # devenv,
    # nixos-unified,
    ...
  }: let
    # Use our custom lib enhanced with nixpkgs and home-manager
  in
    inputs.flake-parts.lib.mkFlake {
      inherit inputs;
      # specialArgs = {inherit lib;};
    } {
      systems = [
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      # debug = true;
      imports = with builtins;
        map (fn: ./modules/flake-parts/${fn})
        (attrNames (readDir ./modules/flake-parts));
      # imports = [
      #   flake-root.flakeModule
      #   nixos-unified.flakeModule
      #   treefmt-nix.flakeModule
      #   devenv.flakeModule
      #   ./users
      #   ./nixvim
      #   ./nix
      #   ./nixos
      #   ./home
      #   ./nix-darwin
      # ];

      # flake = {
      #   nixosConfigurations = {
      #     #main laptop
      #     asuna = self.nixos-flake.lib.mkLinuxSystem ./systems/asuna;
      #
      #     # configuration for WSL
      #     sinon = self.nixos-flake.lib.mkLinuxSystem ./systems/sinon.nix;
      #
      #     kurumi = self.nixos-flake.lib.mkLinuxSystem ./systems/kurumi;
      #   };
      #
      #   darwinConfigurations = {
      #     # M1 Macbook
      #     fenrys = self.nixos-flake.lib.mkMacosSystem ./systems/fenrys.nix;
      #   };
      # };

      # _module.args._inputs = inputs // {inherit self;};

      perSystem = {
        lib,
        system,
        ...
      }: {
        # # make pkgs available to all `perSystem` functions
        # legacyPackages.homeConfigurations."luqman@alya" = self.nixos-flake.lib.mkHomeConfiguration pkgs {
        #   imports = [
        #     self.homeModules.luqman-alya
        #   ];
        # };
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = lib.attrValues self.overlays;
          config.allowUnfree = true;
        };

        # make custom lib available to all `perSystem` functions
        # _module.args.lib = lib;
        #
        # packages = import ./pkgs {inherit pkgs;};
      };
    };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nix-conf.cachix.org"
      "https://ezkea.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-conf.cachix.org-1:ckJrXG+dLoz1zMLNce35EDFGlWcigKdrDlqdmv9kPbE="
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
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
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nh-darwin.url = "github:ToyVo/nh_darwin";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    nvim-nixcats.url = "github:luqmanishere/nvim-nixcats";
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
    nixos-unified.url = "github:srid/nixos-unified";

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
    # hyprland = {
    #   url = "github:hyprwm/Hyprland/v0.41.0";
    #   inputs.nixpkgs.follows = "nixpkgs"; # MESA/OpenGL HW workaround
    # };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1&tag=v0.46.2&rev=0bd541f2fd902dbfa04c3ea2ccf679395e316887";
      inputs.nixpkgs.follows = "nixpkgs"; # MESA/OpenGL HW workaround
    };
    hypridle = {
      url = "github:hyprwm/hypridle/413564cb986cfc67aeb7c4e750b42dc93ff9810f";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock/3d63d9b129d5def270bc8a2471347e6f97274e2b";
    };
    wayper.url = "github:luqmanishere/wayper";
    hyprrdrop.url = "github:luqmanishere/hyprrdrop";
    agenix.url = "github:ryantm/agenix";
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixvim = {
      url = "github:nix-community/nixvim";
      # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay.url = "github:nix-community/emacs-overlay";

    devenv.url = "github:cachix/devenv";
    # to remove warnings on nix flake check
    nix2container.url = "github:nlewo/nix2container";
    nix2container.inputs = {nixpkgs.follows = "nixpkgs";};
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
