# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.xremap-flake.nixosModules.default
    # Include the results of the hardware scan.
    ./hw-conf/asuna-hc.nix
  ];

  # This is disabled to let lanzaboote manage it
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_2;

  # use the latest zen kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  # use the experimental bootspec
  # boot.bootspec.enable = true;
  # boot.loader.systemd-boot.enable = lib.mkForce false;
  # boot.lanzaboote = {
  #   enable = true;
  #   pkiBundle = "/etc/secureboot";
  #   configurationLimit = 10;
  # };

  networking.hostName = "asuna"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;

  # Set your time zone.
  time.timeZone = "Asia/Kuala_Lumpur";
  time.hardwareClockInLocalTime = true;

  nixpkgs = {config.allowUnfree = true;};
  nix = {
    # i have no idea what these lines do
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";

      auto-optimise-store = true;

      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      trusted-substituters = ["https://hyprland.cachix.org"];
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [
      # Vulkan
      #amdvlk # Outdated

      # VAAPI
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
  services.blueman.enable = true;

  programs = {
    dconf.enable = true;
    fish.enable = true;
    light.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
    git.enable = true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    };
    adb.enable = true;
    command-not-found.enable = false;
  };

  services.greetd = {
    enable = true;
    settings = {
      vt = 2;
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = false;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
  };
  services.flatpak.enable = true;
  # to ease mount of usbs
  services.udisks2.enable = true;
  services.tailscale.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.luqman = {
    isNormalUser = true;
    extraGroups = ["wheel" "audio" "video" "networkmanager" "podman" "adbusers" "mediacenter"];
    shell = pkgs.fish;
    hashedPassword = "$6$qCj8Szs3ReZHsRHN$nE0ASG2jCRcpryBGXcH9fhJyem1IzH2e1RQzTffkI0bCBOJ1FsOst1Dy8m53nQpzSsEhCR6JVIZ5tcHPmH0bL.";
    packages = with pkgs; [
      tmux
      neovim
      byobu
    ];
  };

  users.groups.mediacenter.gid = 13000;
  systemd.services.tailscale-funnel = {
    unitConfig = {
      Description = "Expose the jellyfin instance via tailscale";
      After = ["tailscaled.service"];
    };

    serviceConfig = {
      ExecStart = "${pkgs.tailscale}/bin/tailscale funnel 8096";
      Restart = "on-failure";
      RestartSec = 3;
    };

    wantedBy = ["multi-user.target"];
  };

  services.xremap = {
    withHypr = true;
    config = {
      modmap = [
        {
          name = "Emacs pinky";
          remap = {
            CapsLock = {
              held = "CTRL_L";
              alone = "CapsLock";
              alone_timeout_millis = 200;
            };
          };
        }
      ];
    };
    userName = "luqman";
    watch = true;
  };

  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "8192";
    }
  ];
  security.pam.services.swaylock = {};
  security.sudo = {
    extraRules = [
      {
        users = ["luqman"];
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
    extraConfig = ''
      Defaults lecture = never
    '';
  };
  security.polkit.enable = true;

  services.tlp = {
    enable = true;
    settings = {};
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wayland
    wayland.dev
    wayland-protocols
    wayland-utils
    wayland-scanner
    vim
    wget
    neovim
    git
    curl
    fish
    gcc
    clang
    python3
    python310Packages.pip
    polkit-kde-agent
    cloudflare-warp
    aria2
    helvum
    ntfsprogs
    qemu
    (
      pkgs.writeShellScriptBin "qemu-system-x86_64-uefi" ''
        qemu-system-x86_64 \
          -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
          "$@" ''
    )
    podman-compose

    steam-tui
    steamcmd

    sbctl
  ];

  systemd = {
    user.services.polkit-kde-authentication-agent-1 = {
      description = "polkit-kde-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  /*
  services.cloudflare-warp = {
    enable = true;
    certificate = "/home/luqman/Cloudflare_CA.crt";
    user = "root";
    group = "root";
  };
  */

  virtualisation = {
    waydroid.enable = false;
    lxd.enable = false;
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # zram swap
  zramSwap = {
    enable = true;
    swapDevices = 1;
    memoryPercent = 25;
    algorithm = "zstd";
  };

  # # warning, here there be dragons
  # # use impermanence
  # environment.persistence."/persist" = {
  #   # hideMounts = true;
  #   directories = [
  #     "/etc/NetworkManager/system-connections"
  #     "/etc/nixos"
  #     "/etc/secureboot"
  #     "/usr/share/waydroid-extra"
  #   ];
  #
  #   files = [
  #     # "/etc/NIXOS"
  #     "/etc/machine-id"
  #     "/root/.local/share/nix/trusted-settings.json"
  #     /*
  #     "/var/lib/NetworkManger/secret_key"
  #     "/var/lib/NetworkManger/seen_bssids"
  #     "/var/lib/NetworkManger/timestamps"
  #     */
  #   ];
  # };

  systemd.tmpfiles.rules = [
    "L+ /lib/${builtins.baseNameOf pkgs.stdenv.cc.bintools.dynamicLinker} - - - - ${pkgs.stdenv.cc.bintools.dynamicLinker}"
    "L+ /lib64 - - - - /lib"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
