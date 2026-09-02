# Container/quadlet definitions for vladilena, sourced from the private
# nix-containers repo. The agenix home-manager module and identityPaths come
# from the `secrets` module — no need to re-import them here.
{ inputs, ... }: {
  flake.modules.homeManager.nix-containers = { ... }: {
    imports = [ inputs.nix-containers.homeManagerModules.containers ];
  };
}
