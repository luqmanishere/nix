# Configurations common to all MacOS systems
{flake, ...}: let
  inherit (flake) config inputs;
  inherit (inputs) self;
in {
  imports = [
    {
      users.users.${flake.config.me.username} = {
        home = "/Users/${flake.config.me.username}";
      };
      home-manager.users.${config.me.username} = {};
      home-manager .sharedModules = [
        self.homeModules.default
        self.homeModules.darwin-only
      ];
    }
    self.nixosModules.common
    # TODO: ragenix
    ./all/users.nix
    ./all/touch-id.nix
    ./all/environment.nix
    ./all/homebrew.nix
    ./all/nh-darwin.nix
  ];

  # removed: nix-darwin manages nix-daemon now
  # services.nix-daemon.enable = true;
  security.pam.enableSudoTouchId = true;
}
