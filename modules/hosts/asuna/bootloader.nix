{...}: {
  flake.modules.nixos.asuna-boot = {pkgs, ...}: {
    # boot.loader.systemd-boot = {
    #   enable = true;
    #   configurationLimit = 5;
    # };
    environment.systemPackages = with pkgs; [sbctl];
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.limine = {
      enable = true;
      maxGenerations = 5;
      secureBoot = {enable = true;};
      extraEntries = ''
        /Windows
          protocol:efi
          path: uuid(7df2b372-d548-41ad-853e-3c2f155c7170):/EFI/Microsoft/Boot/bootmgfw.efi
      '';
    };
  };
}
