{
  perSystem = {
    inputs',
    pkgs,
    lib,
    config,
    system,
    ...
  }: let
    flash-iso-image = image: let
      pv = "${pkgs.pv}/bin/pv";
      fzf = "${pkgs.fzf}/bin/fzf";
    in ''
      set -euo pipefail

      # Build image
      nix build .#${image}

      # Display fzf disk selector
      iso="./result/iso/"
      iso="$iso$(ls "$iso" | ${pv})"
      dev="/dev/$(lsblk -d -n --output RM,NAME,FSTYPE,SIZE,LABEL,TYPE,VENDOR,UUID | awk '{ if ($1 == 1) { print } }' | ${fzf} | awk '{print $2}')"

      # Format
      ${pv} -tpreb "$iso" | sudo dd bs=4M of="$dev" iflag=fullblock conv=notrunc,noerror oflag=sync
    '';
    help-menu = ''
      echo
      echo 🦾 Helper scripts you can run to make your development richer:
      echo 🦾
      ${pkgs.gnused}/bin/sed -e 's| |••|g' -e 's|=| |' <<EOF | ${pkgs.util-linuxMinimal}/bin/column -t | ${pkgs.gnused}/bin/sed -e 's|^|🦾 |' -e 's|••| |g'
      ${lib.generators.toKeyValue {} (lib.mapAttrs (name: value: value.description) config.devenv.shells."default".scripts)}
      EOF
      echo
    '';
    nix-build = host: ''
      set -euo pipefail
      nix build .#nixosConfigurations.${host}.config.system.build.toplevel
    '';

    rebuild-switch = host: ''
      set -euo pipefail
      sudo nixos-rebuild switch --flake .#${host}
    '';

    rebuild-test = host: ''
      set -euo pipefail
      sudo nixos-rebuild test --flake .#${host}
    '';
  in {
    # devShells.default = pkgs.mkShell {
    #   # cf. https://haskell.flake.page/devshell#composing-devshells
    #   inputsFrom = [config.mission-control.devShell];
    # };
    devenv.shells.default = {
      packages = with pkgs; [
      inputs'.nvim-nixcats.packages.nixCats
        neovim
        nil
        alejandra
        nh
        ripgrep
      ];
      scripts = {
        menu = {
          description = "show this menu";
          exec = help-menu;
        };

        # build systems
        nix-build-asuna = {
          description = "Builds toplevel NixOS image for host asuna";
          exec = nix-build "asuna";
        };

        nix-build-kurumi = {
          description = "Builds toplevel NixOS image for host kurumi";
          exec = nix-build "kurumi";
        };

        rebuild-switch-asuna = {
          description = "Switch into the configuration for host asuna";
          exec = rebuild-switch "asuna";
        };

        rebuild-test-asuna = {
          description = "Switch (TEST) into the configuration for host asuna";
          exec = rebuild-test "asuna";
        };

        # ISOs
        flash-asuna-iso = {
          description = "Flash installer-iso image for asuna";
          exec = flash-iso-image "asuna-iso-image";
        };

        # Utils
        fmt = {
          description = "Format the source tree";
          exec = "${lib.getExe config.treefmt.build.wrapper}";
        };

        clean = {
          description = "Cleans any result produced by Nix or associated tools";
          exec = "rm -rf result* *.qcow2";
        };

        run-vm = {
          description = "Executes a VM if output derivation contains one";
          exec = "exec ./result/bin/run-*-vm";
        };
      };
      enterShell = help-menu;
    };
  };
}
