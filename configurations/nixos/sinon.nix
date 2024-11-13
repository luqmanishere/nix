{
  lib,
  pkgs,
  flake,
  ...
}:
with lib; let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    self.nixosModules.common
    self.nixosModules.default-linux
    self.nixosModules.linux-wsl
  ];

  networking.hostName = "sinon";
  nixpkgs.hostPlatform = "x86_64-linux";

  environment.systemPackages = with pkgs; [
    vim
    neovim
    wget
    git
    curl
    fish
    gcc
    clang
  ];

  # Enable home-manager for "luqman" user
  home-manager.users."luqman" = {
    imports = [(self + /configurations/home/luqman.nix)];
  };

  programs.command-not-found.enable = true;
  services.logrotate.enable = false;
  services.udisks2.enable = false;

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "8192";
    }
  ];

  systemd.tmpfiles.rules = [
    "L+ /lib/${builtins.baseNameOf pkgs.stdenv.cc.bintools.dynamicLinker} - - - - ${pkgs.stdenv.cc.bintools.dynamicLinker}"
    "L+ /lib64 - - - - /lib"
  ];

  time.timeZone = "Asia/Kuala_Lumpur";

  system.stateVersion = "22.05";
}
