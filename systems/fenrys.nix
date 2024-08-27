{
  flake,
  lib,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) nixpkgs self;
in {
  imports = [
    self.darwinModules.default
    # "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    self.nixosModules.fenrys
  ];

  nixpkgs.hostPlatform = lib.mkForce "aarch64-darwin";
  networking.hostName = "fenrys";

  # networking.wireless.networks = {
  #   "Sapi" = {pskRaw = "261aa691d2135810dcff3b7b8248f63727c8088b4d9f7618f3685a61ce03b341";};
  # };

  security.pam.enableSudoTouchIdAuth = true;

  # services.openssh.enable = true;
  services.nix-daemon.enable = true;

  # For home-manager to work
  users.users.luqman = {
    name = "luqman";
    home = "/Users/luqman";
  };

  # services.avahi = {
  #   enable = true;
  #   nssmdns4 = true;
  #   publish = {
  #     enable = true;
  #     addresses = true;
  #     domain = true;
  #     hinfo = true;
  #     userServices = true;
  #     workstation = true;
  #   };
  # };

  system.stateVersion = 4; # Did you read the comment?
}
