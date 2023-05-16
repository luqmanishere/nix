# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hw-conf/asuna-hc.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "asuna"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Kuala_Lumpur";
  time.hardwareClockInLocalTime = true;

  nixpkgs = {config.allowUnfree = true;};
  nix = {
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

  # Enable the X11 windowing system.
  #services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  hardware.opengl.enable = true;

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
    hyprland.enable = true;
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

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  #services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.luqman = {
    isNormalUser = true;
    extraGroups = ["wheel" "audio" "video" "networkmanager"];
    shell = pkgs.fish;
    hashedPassword = "$6$qCj8Szs3ReZHsRHN$nE0ASG2jCRcpryBGXcH9fhJyem1IzH2e1RQzTffkI0bCBOJ1FsOst1Dy8m53nQpzSsEhCR6JVIZ5tcHPmH0bL.";
    packages = with pkgs; [
      tmux
      neovim
      byobu
    ];
  };

  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

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

    steam-tui
    steamcmd
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

  virtualisation = {
    waydroid.enable = true;
    lxd.enable = true;
  };

  # zram swap
  zramSwap = {
    enable = true;
    swapDevices = 1;
    memoryPercent = 25;
    algorithm = "zstd";
  };

  # warning, here there be dragons
  # use impermanence
  environment.persistence."/persist" = {
    # hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/nixos"
    ];

    files = [
      "/etc/NIXOS"
      "/etc/machine-id"
      /*
      "/var/lib/NetworkManger/secret_key"
      "/var/lib/NetworkManger/seen_bssids"
      "/var/lib/NetworkManger/timestamps"
      */
    ];
  };

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
