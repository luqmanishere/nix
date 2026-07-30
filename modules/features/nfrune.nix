{inputs, ...}: {
  flake.modules.homeManager.nfrune-server = {config, ...}: {
    imports = [
      inputs.nfrune.homeManagerModules.nfrune-gateway
      inputs.nfrune.homeManagerModules.nfrune-relay
      inputs.nfrune.homeManagerModules.nfrune-device-bridge
    ];

    age.secrets.nfrune-telegram.file = ./secrets/nfrune-telegram.age;

    services.nfrune-gateway = {
      enable = true;
      environmentFile =
        config.age.secrets.nfrune-telegram.path;
    };

    services.nfrune-relay = {
      enable = true;
      bind = "127.0.0.1:8787";
      credentialsFile = "%h/.config/nfrune/relay-credentials.json";
    };

    services.nfrune-device-bridge = {
      enable = true;
      configFile = "%h/.config/nfrune/device-bridge.json";
    };
  };

  flake.modules.homeManager.nfrune-client = {config, ...}: {
    imports = [
      inputs.nfrune.homeManagerModules.nfrune-ipc
      inputs.nfrune.homeManagerModules.nfrune-device-bridge
    ];

    services.nfrune-ipc.enable = true;

    services.nfrune-device-bridge = {
      enable = true;
      configFile = "%h/.config/nfrune/device-bridge.json";
    };
  };
}
