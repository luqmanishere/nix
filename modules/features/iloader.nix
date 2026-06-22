{...}: {
  flake.modules.nixos.iloader = {pkgs, ...}: {
    services.usbmuxd.enable = true;

    environment.systemPackages = with pkgs; [iloader];
  };
}
