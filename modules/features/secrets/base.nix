{inputs, ...}: {
  flake.modules.homeManager.secrets = {
    lib,
    config,
    ...
  }: {
    imports = [
      inputs.agenix.homeManagerModules.default
    ];
    age = {
      identityPaths = ["${config.home.homeDirectory}/.ssh/agenix" "${config.home.homeDirectory}/.ssh/general"];
      secretsDir = "${config.home.homeDirectory}/.agenix/agenix";
      secretsMountPoint = "${config.home.homeDirectory}/.agenix/agenix.d";
    };
  };
}
