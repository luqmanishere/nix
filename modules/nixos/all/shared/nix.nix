{
  flake,
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  inherit (flake) inputs;
  cfg = config.modules.nix;
in {
  options.modules.nix.latest = mkOption {
    description = "Use latest version of nix";
    type = types.bool;
    default = true;
  };
  config = mkMerge [
    (mkIf cfg.latest {
      nix.package = pkgs.nixVersions.latest;
    })
    {
      nixpkgs = {
        config = {
          allowUnfree = true;
        };

        # put nixos overlays here
        overlays = [inputs.emacs-overlay.overlays.package];
      };

      nix = {
        nixPath = ["nixpkgs=${flake.inputs.nixpkgs}"]; # Enables use of `nix-shell -p ...` etc
        registry.nixpkgs.flake = flake.inputs.nixpkgs; # Make `nix shell` etc use pinned nixpkgs
        settings = {
          max-jobs = "auto";
          experimental-features = "nix-command flakes";

          # for non intel macs
          # extra-platforms = lib.mkIf pkgs.stdenv.isDarwin "aarch64-darwin x86_64-darwin";

          # Nullify the registry for purity.
          flake-registry = builtins.toFile "empty-flake-registry.json" ''{"flakes":[],"version":2}'';
          trusted-users = [
            "root"
            (
              if pkgs.stdenv.isDarwin
              then flake.config.me.username
              else "@wheel"
            )
            "luqman"
          ];

          substituters = ["https://nixos-apple-silicon.cachix.org"];
          trusted-public-keys = ["nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="];
          trusted-substituters = ["https://nixos-apple-silicon.cachix.org"];
        };
        optimise.automatic = true;
      };
    }
  ];
}
