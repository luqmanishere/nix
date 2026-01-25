{
  flake,
  lib,
  ...
}: let
  inherit (flake) inputs;
in {
  imports = [inputs.nixos-wsl.nixosModules.default];

  wsl = {
    enable = true;
    defaultUser = "luqman";

    startMenuLaunchers = true;

    interop = {
      register = false;
      includePath = false;
    };

    wslConf = {
      network.hostname = "sinon";
      automount.root = "/mnt";
    };
  };
}
