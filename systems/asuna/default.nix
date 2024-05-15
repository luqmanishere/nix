# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  flake,
  lib,
  pkgs,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    self.nixosModules.asuna

    # TODO: move to a module
    inputs.xremap-flake.nixosModules.default
    # Include the results of the hardware scan.
    ./hardware.nix
  ];

  networking = {
    hostName = "asuna"; # Define your hostname.
    networkmanager.enable = true;
    networkmanager.wifi.powersave = false;

    firewall = {
      # Open ports in the firewall.
      allowedTCPPorts = [22 8989 6881 8112 8096 8920];
      allowedUDPPorts = [6881 1990 7359];
      # Or disable the firewall altogether.
      enable = true;
    };
  };

  time = {
    # Set your time zone.
    timeZone = "Asia/Kuala_Lumpur";
    hardwareClockInLocalTime = true;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  hardware = {
    opengl = {
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
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    pulseaudio.enable = false;
  };

  services = {
    blueman.enable = true;

    # TODO: maybe find a better alternative?
    greetd = {
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
    printing.enable = true;
    pipewire = {
      enable = true;
      audio.enable = true;
      wireplumber.enable = true;
      pulse.enable = true;
      alsa.enable = true;
      jack.enable = true;
    };
    flatpak.enable = true;
    # to ease mount of usbs
    udisks2.enable = true;
    tailscale.enable = true;

    protonvpn = {
      enable = true;
      autostart = false;
      interface = {
        ip = "10.2.0.2/32";
        privateKeyFile = "/etc/protonkey";
        dns = {
          enable = true;
          ip = "10.2.0.1";
        };
      };
      endpoint = {
        publicKey = "6vLkUgiS/K8p5dTMwUQo6tiyJ65DrM8E2mwO+QFz/zs=";
        ip = "138.199.21.206";
        port = 51820;
      };
    };

    # TODO: move xremap to dedicated module
    xremap = {
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

    tlp = {
      enable = true;
      settings = {};
    };

    # Enable the OpenSSH daemon.
    openssh.enable = true;
    resolved = {
      enable = true;
      fallbackDns = ["1.1.1.1" "8.8.8.8"];
    };

    logind = {
      lidSwitch = "ignore";
      lidSwitchDocked = "ignore";
      lidSwitchExternalPower = "ignore";
    };
  };
  networking.networkmanager.connectionConfig = {"connection.mdns" = 2;};

  programs = {
    dconf.enable = true;
    light.enable = true;
    git.enable = true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    };
    adb.enable = true;
    command-not-found.enable = false;
  };

  # Enable sound.
  sound.enable = false;

  security = {
    rtkit.enable = true;

    pam.loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "nofile";
        value = "8192";
      }
    ];
    pam.services.swaylock = {};
    sudo = {
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
    polkit.enable = true;
  };

  # TODO: refactor into own module
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

  # TODO: refactor into own module
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # TODO: wth do i do with this?
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

  virtualisation = {
    waydroid.enable = true;
    lxd.enable = true;
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
