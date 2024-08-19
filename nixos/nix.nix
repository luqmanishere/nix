{
  flake,
  pkgs,
  ...
}: let
  inherit (flake) inputs;
in {
  nixpkgs = {
    config = {
      allowUnfree = true;
    };

    # put nixos overlays here
    overlays = [inputs.emacs-overlay.overlays.package];
  };

  nix = {
    package = pkgs.nixVersions.latest;
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
          then flake.config.people.myself
          else "@wheel"
        )
        "luqman"
      ];

      auto-optimise-store = true;

      # substituters = ["https://hyprland.cachix.org"];
      # trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      # trusted-substituters = ["https://hyprland.cachix.org"];
    };
  };

  # increase open file settings for nix
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "8192";
    }
  ];
}
