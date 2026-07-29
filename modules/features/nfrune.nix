{inputs, ...}: {
  flake.modules.homeManager.nfrune = {config, ...}: {
    imports = [
      inputs.nfrune.homeManagerModules.nfrune-gateway
    ];

    age.secrets.nfrune-telegram.file = ./secrets/nfrune-telegram.age;

    services.nfrune-gateway = {
      enable = true;
      environmentFile =
        config.age.secrets.nfrune-telegram.path;
    };
  };
}
