{
  inputs,
  config,
  ...
}: let
  config-flake = config;
in {
  flake.modules.nixos."hosts/sinon" = {
    config,
    pkgs,
    lib,
    ...
  }: {
    imports = with config-flake.flake.modules.nixos;
      [inputs.nixos-wsl.nixosModules.default]
      ++ [
        base
        users
        nix
        inputs.vscode-server.nixosModules.default
      ]
      ++ [
        {
          home-manager.users.luqman = {
            imports = with config-flake.flake.modules.homeManager; [
              base
              secrets
              shell
              helix
              zellij
              fonts
              task
              ai
              emacs
              sync
            ];
          };
        }
      ];

    networking.hostName = "sinon";
    nixpkgs.hostPlatform = "x86_64-linux";

    programs.command-not-found.enable = true;
    services.logrotate.enable = false;
    services.udisks2.enable = false;

    # TODO: decide what module this belongs in
    systemd.tmpfiles.rules = [
      "L+ /lib/${baseNameOf pkgs.stdenv.cc.bintools.dynamicLinker} - - - - ${pkgs.stdenv.cc.bintools.dynamicLinker}"
      "L+ /lib64 - - - - /lib"
    ];

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
  };
}
