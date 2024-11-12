{lib, ...}: {
  boot = {
    # TODO: reimplement and writeup
    # use the experimental bootspec
    bootspec.enable = true;
    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
      configurationLimit = 10;
    };
  };
}
