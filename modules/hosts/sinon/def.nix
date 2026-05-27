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
              email
              music
            ];

            programs.fish.interactiveShellInit = ''
              if status is-interactive; and test -r /proc/sys/kernel/osrelease
                      if string match -qi '*microsoft*' -- (cat /proc/sys/kernel/osrelease)
                        set -l runtime_dir /run/user/(id -u)
                        if set -q XDG_RUNTIME_DIR
                          set runtime_dir $XDG_RUNTIME_DIR
                        end

                        set -l marker $runtime_dir/.wsl-systemd-env-imported

                        if not test -e $marker
                          systemctl --user import-environment \
                            DISPLAY WAYLAND_DISPLAY XAUTHORITY SSH_AUTH_SOCK PULSE_SERVER \
                            DBUS_SESSION_BUS_ADDRESS PATH
                          touch $marker
                        end
                      end
                    end
            '';
          };
        }
      ];

    networking.hostName = "sinon";
    nixpkgs.hostPlatform = "x86_64-linux";

    programs.command-not-found.enable = true;
    services.logrotate.enable = false;
    services.udisks2.enable = false;
    services.vscode-server.enable = true;

    # TODO: decide what module this belongs in
    # systemd.tmpfiles.rules = [
    #   "L+ /lib/${baseNameOf pkgs.stdenv.cc.bintools.dynamicLinker} - - - - ${pkgs.stdenv.cc.bintools.dynamicLinker}"
    #   "L+ /lib64 - - - - /lib"
    # ];

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

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    virtualisation.docker = {
      enable = true;
      daemon.settings = {
        # dns = ["1.1.1.1"];
      };
    };
  };
}
