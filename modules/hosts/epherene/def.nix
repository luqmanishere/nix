{
  inputs,
  config,
  ...
}: let
  config-flake = config;
in {
  flake.modules.nixos."hosts/epherene" = {
    config,
    pkgs,
    lib,
    ...
  }: {
    imports = with config-flake.flake.modules.nixos;
      [
        inputs.nixos-apple-silicon.nixosModules.default
        base
        epherene-boot
        epherene-bt
        containers
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
        # TODO: refactor these into its own modules
        inputs.vscode-server.nixosModules.default
        inputs.titdb.nixosModules.default
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
              sherlock
              hypridle
              hyprlock
              quickshell
              wayland-utils
              wayper
              task
              ai
            ];
          };
        }
      ];

    networking.hostName = "epherene";

    hardware.asahi = {
      peripheralFirmwareDirectory = ./firmware;
      setupAsahiSound = true;
    };

    programs.fish.enable = true;

    nixpkgs.hostPlatform = {system = "aarch64-linux";};

    nixpkgs.overlays = [
      # TODO: niri should be its own feature
      inputs.nixos-apple-silicon.overlays.apple-silicon-overlay

      (self: super: {
        virglrenderer = super.virglrenderer.overrideAttrs (oldAttrs: {
          src = super.fetchurl {
            url = "https://gitlab.freedesktop.org/asahi/virglrenderer/-/archive/asahi-20250424/virglrenderer-asahi-20250424.tar.bz2";
            hash = "sha256-9qFOsSv8o6h9nJXtMKksEaFlDP1of/LXsg3LCRL79JM=";
          };
          mesonFlags = oldAttrs.mesonFlags ++ [(super.lib.mesonOption "drm-renderers" "asahi-experimental")];
        });
      })
    ];

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
    services.titdb = {
      enable = true;
      device = "/dev/input/by-path/platform-23510c000.spi-cs-0-event-mouse";
      topPercentage = 15;
    };

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
      blueberry
      # muvm
      # fex
      bash
      perf
      distrobox
      wireguard-tools
      libnotify
      jq
    ];

    services.openssh.enable = true;

    hardware.graphics.package = lib.mkForce pkgs.mesa;

    services.logind.powerKey = "suspend";
    boot.initrd.systemd.enable = true;
    boot.initrd.availableKernelModules = ["usb_storage"];
    boot.supportedFilesystems = ["bcachefs"];
    boot.kernelParams = lib.mkForce [
      "quiet"
      "earlycon"
      # "console=ttySAC0,115200n8"
      "console=tty0"
      "boot.shell_on_fail"
      "nvme_apple.flush_interval=0"
      "root=fstab"
      "splash"
      "loglevel=4"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      # zswap config
      "zswap.enabled=1"
      "zswap.compressor=zstd"
      "zswap.zpool=zsmalloc"
      "zswap.max_pool_percent=50"
      # disable ipv6
      "ipv6.disable=1"
    ];

    fileSystems."/" = {
      device = "UUID=22b0afa2-23b7-4e79-8ad7-f4a122f161ee";
      fsType = "bcachefs";
      options = ["noatime"];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/226D-1EF3";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/a56e536e-9cfe-489a-8208-c79ee73c08e3";}
    ];

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlan0.useDHCP = lib.mkDefault true;
  };
}
