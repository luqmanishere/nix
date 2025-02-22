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
    ./hm.nix
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
