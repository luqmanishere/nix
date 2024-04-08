{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.agenix.homeManagerModules.default
  ];

  age = {
    identityPaths = ["/home/luqman/.ssh/agenix"];
    secretsDir = "${config.home.homeDirectory}/.agenix/agenix";
    secretsMountPoint = "${config.home.homeDirectory}/.agenix/agenix.d";

    secrets.taskd_credentials.file = ./taskd_credentials.age;
    secrets.taskd_ca.file = ./taskd_ca.age;
    secrets.taskd_key.file = ./taskd_key.age;
    secrets.taskd_cert.file = ./taskd_cert.age;
  };
}
