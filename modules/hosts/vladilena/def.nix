{
  inputs,
  config,
  ...
}: let
  config-flake = config;
in {
  flake.modules.nixos."hosts/vladilena" = {
    lib,
    pkgs,
    flake,
    ...
  }:
    with lib; let
      inherit (flake) inputs;
      inherit (inputs) self;
    in {
      imports = with config-flake.flake.modules.nixos; [
        base
        polkit
        users
        containers
        nix
      ];

      home-manager.users.luqman = {
        imports = with config-flake.flake.modules.homeManager; [
          base
          secrets
          shell
          helix
          fonts
          zellij
          ai
          task
          emacs
        ];
      };

      networking.hostName = "vladilena";
      networking.networkmanager.enable = true;
      # firewall is handled by the cloud platform
      networking.firewall.enable = false;
      networking.nat = {
        enable = true;
        externalInterface = "enp0s6";
        internalInterfaces = ["wg0"];
      };
      networking.wireguard.enable = true;
      networking.wireguard.interfaces = {
        wg0 = {
          ips = ["10.45.10.1/24"];
          listenPort = 53;
          mtu = 1280;

          postSetup = ''
            ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.45.10.0/24 -o enp0s6 -j MASQUERADE
          '';

          # Undo the above
          postShutdown = ''
            ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.45.10.0/24 -o enp0s6 -j MASQUERADE
          '';

          privateKey = "oBEH1sE5qpOQgUIFuWvHrVfASiIsHyv7rV6I0yfk6WA=";
          peers = [
            {
              publicKey = "RZoF54SJaUInC5kG2NGLYieMvlshXb2yM82l4ObsEkc=";
              allowedIPs = [
                "10.45.10.2/32"
              ];
            }
            {
              publicKey = "nT2z7PLICcfw4k5rTmax95DprD5TdgHM1kJpsKZTtwA=";

              allowedIPs = [
                "10.45.10.3/32"
                "192.10.23.0/24"
                "190.1.108.0/24"
              ];
            }
          ];
        };
      };

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
        wireguard-tools
      ];

      boot = {
        loader = {
          systemd-boot.enable = true;
          systemd-boot.configurationLimit = 3;
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

      virtualisation.docker = {enable = true;};

      # Disable autologin.
      services.getty.autologinUser = null;

      boot.kernel.sysctl = {"net.ipv4.ip_unprivileged_port_start" = 80;};

      boot.initrd.availableKernelModules = ["xhci_pci" "virtio_scsi"];
      boot.initrd.kernelModules = [];
      boot.kernelModules = [];
      boot.extraModulePackages = [];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/2aa6a786-04c8-4506-a3b7-a1457e202bec";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/9E63-CAF8";
        fsType = "vfat";
        options = ["fmask=0022" "dmask=0022"];
      };

      fileSystems."/mnt/data" = {
        device = "/dev/disk/by-uuid/7a9cae89-f723-466d-9185-61e1b948fbf8";
        fsType = "xfs";
        options = ["defaults" "users" "_netdev" "rw" "exec"];
      };

      swapDevices = [];

      # Disable documentation for minimal install.
      documentation.enable = false;

      system.stateVersion = "24.11"; # Did you read the comment?
    };
}
