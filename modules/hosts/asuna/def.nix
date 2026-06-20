{
  inputs,
  config,
  ...
}: let
  config-flake = config;
in {
  flake.modules.nixos."hosts/asuna" = {
    config,
    pkgs,
    lib,
    modulesPath,
    ...
  }: {
    imports = with config-flake.flake.modules.nixos;
      [
        (modulesPath + "/installer/scan/not-detected.nix")
        base
        asuna-boot
        asuna-bt
        asuna-fingerprint
        containers
        secrets
        networking
        laptop
        bootanim
        polkit
        users
        nix
        mdns
        onepassword
        niri
        tuigreet
        steam
        aagl

        inputs.chaotic.nixosModules.default
        # TODO: refactor these into its own modules
        inputs.vscode-server.nixosModules.default
        # inputs.titdb.nixosModules.default
      ]
      ++ [
        {
          home-manager.users.luqman = {
            imports = with config-flake.flake.modules.homeManager; [
              base
              secrets
              shell
              firefox
              chromium
              helix
              comms
              productivity
              kitty
              zellij
              fonts
              niri
              hypridle
              hyprlock
              quickshell
              wayland-utils
              wayper
              task
              ai
              dev-tools
              vscode
              emacs
              zed
              vicinae
              sync
              zen
              music
              email
            ];
          };
        }
      ];

    networking.hostName = "asuna";

    programs.fish.enable = true;

    # TODO: own feature
    services.vscode-server.enable = true;

    # TODO: own feature
    virtualisation.docker = {
      enable = true;
      daemon.settings = {
        # dns = ["1.1.1.1"];
      };
    };

    # TODO: feature
    # reject some areas of the trackpad smartly
    # services.titdb = {
    #   enable = true;
    #   device = "/dev/input/by-path/platform-23510c000.spi-cs-0-event-mouse";
    #   topPercentage = 15;
    # };

    # TODO: feature
    services.printing.enable = true;

    # TODO: refactor as feature
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      neovim
      tmux
      git
      curl
      alacritty
      xwayland-satellite
      blueman
      bluetui
      bash
      perf
      distrobox
      wireguard-tools
      libnotify
      jq
      pwvucontrol
      config.boot.kernelPackages.cpupower
      usbutils
      tpm2-tss
    ];

    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;
    hardware.graphics.extraPackages = with pkgs; [vpl-gpu-rt];

    virtualisation.waydroid.enable = true;
    virtualisation.waydroid.package = pkgs.waydroid-nftables;

    services.openssh.enable = true;
    services.sunshine = {
      enable = true;
      autoStart = false; # optional: starts Sunshine automatically on login
      capSysAdmin = true;
      openFirewall = true;
    };

    services.logind.powerKey = "suspend";

    age.secrets.wg-asuna = {
      file = ./wg-asuna.age;
      mode = "640";
      owner = "systemd-network";
      group = "systemd-network";
    };
    systemd.network = {
      networks."50-wg0" = {
        matchConfig = {Name = "wg0";};

        address = ["10.45.10.4/32"];
      };

      netdevs."50-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
          MTUBytes = 1280;
        };

        wireguardConfig = {
          RouteTable = "main";
          PrivateKeyFile = config.age.secrets.wg-asuna.path;
        };
        wireguardPeers = [
          {
            PublicKey = "2x1QVzbgjvnSlTmb4/9o9MnExnn+CTF4JVKO7NcYrlY=";
            AllowedIPs = ["10.45.10.0/24" "190.1.108.30"];
            Endpoint = "solemnattic.dev:53";
          }
        ];
      };
    };

    boot.initrd.systemd.enable = true;

    boot.kernelPackages = pkgs.linuxPackages_cachyos;
    boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-intel"];
    boot.extraModulePackages = [];

    fileSystems."/" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = ["subvol=@" "noatime" "ssd" "compress=zstd:3" "space_cache=v2"];
    };

    boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/c3b6cfb3-d1e0-4e7a-a21d-566091b65477";

    fileSystems."/home" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = ["subvol=@home" "noatime" "ssd" "compress=zstd:3" "space_cache=v2"];
    };

    fileSystems."/nix" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = ["subvol=@nix" "noatime" "ssd" "compress=zstd:3" "space_cache=v2"];
    };

    fileSystems."/var/log" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = ["subvol=@log" "noatime" "ssd" "compress=zstd:3" "space_cache=v2"];
    };

    fileSystems."/.snapshots" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = ["subvol=@snapshots" "noatime" "ssd" "compress=zstd:3" "space_cache=v2"];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/EA31-B95F";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    swapDevices = [
      {
        device = "/swaps/swapfile";
        size = 8 * 1024; # Creates an 8GB swap file
      }
      {
        device = "/swaps/swapfile2";
        size = 8 * 1024; # Creates an 8GB swap file
      }
    ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.npu.enable = true;
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlan0.useDHCP = lib.mkDefault true;
  };
}
