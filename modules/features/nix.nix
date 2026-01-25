{inputs, ...}: {
  flake.modules.nixos.nix = {pkgs, ...}: {
    nixpkgs = {
      config = {
        allowUnfree = true;
      };

      # put nixos overlays here
      overlays = [inputs.emacs-overlay.overlays.package];
    };
    nix = {
      package = pkgs.nixVersions.latest;
      nixPath = ["nixpkgs=${inputs.nixpkgs}"]; # Enables use of `nix-shell -p ...` etc
      registry.nixpkgs.flake = inputs.nixpkgs; # Make `nix shell` etc use pinned nixpkgs
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
            then "luqmanul"
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

    # TODO: add other nix options here
    security.pam.loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "nofile";
        value = "8192";
      }
    ];
  };

  flake.modules.homeManager.nix = {pkgs, ...}: {
    nix = {
      gc.automatic = true;
      package = pkgs.nixVersions.latest;
    };
  };
}
