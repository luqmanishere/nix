{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  modules = inputs.haumea.lib.load {
    src = ./modules;
    inputs = {
      inherit pkgs lib inputs config;
    };
  };
}
