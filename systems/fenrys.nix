{
  flake,
  lib,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) nixpkgs self;
in {
  imports = [
    self.nixosModules.fenrys
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
  ];

  time.timeZone = "Asia/Kuala_Lumpur";
  i18n.defaultLocale = "en_US.UTF8";
  sdImage.compressImage = false;

  networking.wireless.networks = {
    "Sapi" = {pskRaw = "261aa691d2135810dcff3b7b8248f63727c8088b4d9f7618f3685a61ce03b341";};
  };

  networking.hostName = "fenrys";

  users.users.luqman.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDW+oXpKYSILzxc4O5Nrlf1oObQQc4XrawHWQmd5yvspQI6G5138KhX4woq65P1dGRguLvj3wWwJt5zKf533995radcusma9G1YDMWgkq+bKz+eNvY4n3zkA3EeKAlLsdwf/bA1ydLqK/LOTmBjTQqoxJsiQ7sqWCQFKZxRPlaRKsEnL8PmhkQNll8sJJ0GY559kODKArAjqYxNVPnOjijfl80WjIplrxKOdlaK79zJxv955lQTRNotI/wITnbOSpi2IMrbhCXQ5IViVj1fr5CwxPO1hrz5wRaycUhErtxzQS+Cvfkp5ooaOJSNRtmxoGC0hPxO8Vi+SrL28mH8ziPn"
  ];

  services.openssh.enable = true;

  nixpkgs.hostPlatform = lib.mkForce "aarch64-linux";

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  system.stateVersion = "22.11"; # Did you read the comment?
}
