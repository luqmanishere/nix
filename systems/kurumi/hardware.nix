# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ahci" "firewire_ohci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = ["wl"];
  boot.kernelModules = [ "kvm-intel" "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  boot.blacklistedKernelModules = ["b43" "bcma"];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/de13094e-00c0-4cfa-80d6-21ad5a8b879b";
      fsType = "btrfs";
      options = [ "subvol=root" "noatime" "compress=zstd"];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/5EB2-72D5";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/de13094e-00c0-4cfa-80d6-21ad5a8b879b";
      fsType = "btrfs";
      options = [ "subvol=home" "noatime" "compress=zstd"];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/de13094e-00c0-4cfa-80d6-21ad5a8b879b";
      fsType = "btrfs";
      options = [ "subvol=nix" "noatime" "compress=zstd"];
    };

  fileSystems."/var/lib" =
    { device = "/dev/disk/by-uuid/de13094e-00c0-4cfa-80d6-21ad5a8b879b";
      fsType = "btrfs";
      options = [ "subvol=var/lib" "noatime" "compress=zstd"];
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-uuid/de13094e-00c0-4cfa-80d6-21ad5a8b879b";
      fsType = "btrfs";
      options = [ "subvol=var/log" "noatime" "compress=zstd"];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0f0.useDHCP = lib.mkDefault true;
  # networking.interfaces.eth0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}