{inputs, ...}: {
  imports = [
    inputs.nixos-unified.flakeModules.default
    inputs.nixos-unified.flakeModules.autoWire
  ];
  perSystem = {self', ...}: {
    packages.default = self'.packages.activate;
  };
}
