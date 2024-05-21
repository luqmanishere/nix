{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    # build stuff for rpi
    binfmt.emulatedSystems = ["aarch64-linux"];

    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
    };

    # use the latest zen kernel
    kernelPackages = pkgs.linuxPackages_zen;

    initrd = {
      # TODO: resetup impermeanance

      availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "usbhid" "sd_mod"];
      kernelModules = [];

      luks.devices."enc".device = "/dev/disk/by-uuid/2f22d311-7714-4816-a444-39c1b87fbe20";
    };

    kernelModules = ["kvm-amd"];
    extraModulePackages = [];

    extraModprobeConfig = ''
      options snd-hda-intel model=auto,dell-headset-multi
    '';
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/4552826e-cbe0-43c4-abd4-1d86248ac5ab";
      fsType = "btrfs";
      options = ["subvol=root" "compress=zstd" "noatime"];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/4552826e-cbe0-43c4-abd4-1d86248ac5ab";
      fsType = "btrfs";
      options = ["subvol=home" "compress=zstd" "noatime"];
    };

    "/var/log" = {
      device = "/dev/disk/by-uuid/4552826e-cbe0-43c4-abd4-1d86248ac5ab";
      fsType = "btrfs";
      options = ["subvol=var/log" "compress=zstd" "noatime"];
    };

    "/var/lib" = {
      device = "/dev/disk/by-uuid/4552826e-cbe0-43c4-abd4-1d86248ac5ab";
      fsType = "btrfs";
      options = ["subvol=var/lib" "compress=zstd" "noatime"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/4552826e-cbe0-43c4-abd4-1d86248ac5ab";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/E8FE-853C";
      fsType = "vfat";
    };

    "/mnt/windowsc" = {
      device = "/dev/disk/by-uuid/ACFA1C91FA1C59C2";
      fsType = "ntfs3";
      options = ["user" "exec" "rw" "uid=1000" "gid=1000"];
    };

    # "/mnt/windowsd" = {
    #   device = "/dev/disk/by-uuid/DA1AAC921AAC6CE7";
    #   fsType = "ntfs3";
    #   options = ["user" "exec" "rw" "uid=1000" "gid=1000"];
    # };

    "/mnt/storage2/jellyfin" = {
      device = "/dev/disk/by-uuid/39ea80c4-e748-47eb-835c-64025de53e26";
      fsType = "btrfs";
      options = ["subvol=jellyfin" "compress=zstd" "rw" "user" "exec" "nofail"];
    };

    "/mnt/storage2/rustic-repo" = {
      device = "/dev/disk/by-uuid/39ea80c4-e748-47eb-835c-64025de53e26";
      fsType = "btrfs";
      options = ["subvol=rustic-repo" "compress=zstd" "rw" "user" "exec" "nofail"];
    };

    "/mnt/storage2/games" = {
      device = "/dev/disk/by-uuid/39ea80c4-e748-47eb-835c-64025de53e26";
      fsType = "btrfs";
      options = ["subvol=games" "compress=zstd" "rw" "user" "exec" "nofail"];
    };
  };
  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
