{
  flake,
  lib,
  pkgs,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) nixpkgs self;
in {
  imports = [
    self.darwinModules.default
    self.nixosModules.common # common modules
  ];

  nixpkgs.hostPlatform = lib.mkForce "aarch64-darwin";
  networking.hostName = "fenrys";

  # networking.wireless.networks = {
  #   "Sapi" = {pskRaw = "261aa691d2135810dcff3b7b8248f63727c8088b4d9f7618f3685a61ce03b341";};
  # };

  # services.openssh.enable = true;

  # For home-manager to work
  users.users.luqman = {
    name = "luqman";
    home = "/Users/luqman";
  };

  home-manager.users."luqman" = {
    imports = [
      (self + /configurations/home/luqman.nix)
      {imports = [self.homeModules.darwin-only];}
      self.homeModules.common
    ];

    modules.core.gui.enable = true;

    modules.editors.helix.enable = true;

    modules.terminals.zellij.enable = true;
    modules.terminals.kitty.enable = true;
    modules.tools.fonts.enable = true;
  };

  environment.systemPackages = with pkgs; [pandoc];

  system.stateVersion = 4; # Did you read the comment?
}
