{ lib, pkgs, config, modulesPath, ... }:

with lib;
let
  nixos-wsl = import ./nixos-wsl;
in
{
  imports = [
    nixos-wsl.nixosModules.wsl
  ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "luqman";
    startMenuLaunchers = true;

    interop = {
    	register = false;
    };

    wslConf = {
	network.hostname = "nixos-wsl";
    };

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;

  };

  users.users.luqman = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
    packages = with pkgs; [
      tmux
      neovim
      byobu
    ];
  };

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim
    wget
    git
    curl
    fish
    gcc
    clang
  ];
  # Enable nix flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.noXlibs =  true;
  documentation.enable =  true;
  documentation.doc.enable =  true;
  documentation.info.enable =  true;
  documentation.man.enable =  true;
  documentation.nixos.enable =  true;

  programs.command-not-found.enable = true;
  services.logrotate.enable = false;
  services.udisks2.enable =  false;

  system.stateVersion = "22.05";
}
