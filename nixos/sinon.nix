{
  lib,
  pkgs,
  config,
  modulesPath,
  inputs,
  ...
}:
with lib; {
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
  ];

  wsl = {
    enable = true;
    defaultUser = "luqman";
    startMenuLaunchers = true;
    nativeSystemd = true;

    interop = {
      register = false;
      includePath = false;
    };

    wslConf = {
      network.hostname = "sinon";
      automount.root = "/mnt";
    };

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
  };

  users.users.luqman = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
    uid = 1000;
    createHome = true;
    initialHashedPassword = "$y$j9T$jkFS1qQP.LZx3FHiWHZvk0$xlGgXWMx8nPgHfaVP3ESseZLsQjjoY6k.V4RGHcSpVC";
    description = "Luqmanul Hakim";
    packages = with pkgs; [
      tmux
      neovim
      byobu
    ];
  };

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

  # Enable nix flakes
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.noXlibs = true;
  documentation.enable = true;
  documentation.doc.enable = true;
  documentation.info.enable = true;
  documentation.man.enable = true;
  documentation.nixos.enable = true;

  programs.command-not-found.enable = true;
  programs.fish.enable = true;
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
