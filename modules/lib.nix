# from not-a-number.io
{inputs, ...}: {
  flake.lib = {
    loadNixosAndHmModuleForUser = config: modules: username:
      assert builtins.isAttrs config;
      assert builtins.isList modules;
      assert builtins.isString username; {
        imports =
          (map (module: config.flake.modules.nixos.${module} or {}) modules)
          ++ [
            {
              imports = [
                inputs.home-manager.nixosModules.home-manager
              ];

              home-manager.users.${username}.imports =
                [
                  (
                    {osConfig, ...}: {
                      home.stateVersion = osConfig.system.stateVersion;
                    }
                  )
                ]
                ++ map (module: config.flake.modules.homeManager.${module} or {}) modules;
            }
          ];
      };
  };
}
