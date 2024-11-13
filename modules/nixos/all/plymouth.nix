{
  lib,
  pkgs,
  ...
}: {
  boot = {
    kernelParams = ["quiet"];
    initrd.systemd.enable = lib.mkForce true;
    plymouth = {
      enable = true;
      themePackages = with pkgs; [adi1090x-plymouth-themes];
      theme = "angular";
    };
  };
}
