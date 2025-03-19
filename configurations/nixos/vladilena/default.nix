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
    ./hm.nix
    self.nixosModules.common
    self.nixosModules.default-linux
    self.nixosModules.linux-server
    ./hardware.nix
  ];

  networking.hostName = "vladilena";
  networking.networkmanager.enable = true;
  # firewall is handled by the cloud platform
  networking.firewall.enable = false;

  users.users."luqman".linger = true;

  nixpkgs.hostPlatform = "aarch64-linux";

  environment.systemPackages = with pkgs; [
    curl
    git
    vim
    wget
    vim
    neovim
    fish
    gcc
    clang
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
    initrd.systemd.enable = true;
  };

  time.timeZone = "Asia/Kuala_Lumpur";
  i18n.defaultLocale = "en_US.UTF-8";

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

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Disable autologin.
  services.getty.autologinUser = null;

  boot.kernel.sysctl = {"net.ipv4.ip_unprivileged_port_start" = 80;};

  # Open ports in the firewall.

  # Disable documentation for minimal install.
  documentation.enable = false;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
