{...}: {
  flake.modules.nixos.epherene-boot = {
    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
    boot.loader.efi.canTouchEfiVariables = false;
  };
}
