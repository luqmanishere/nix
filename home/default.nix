{
  self,
  lib,
  ...
}: {
  flake = {
    homeModules = {
      # common modules that should be imported by everyone.
      # these modules should be usable in all environments
      common = {
        imports = [
          ./configopts.nix
          # ./editors/lazyvim # deprecated
          ./editors/nvim-nixcats.nix
          ./tools/shell.nix
          ./tools/starship.nix
          ./terminals/zellij.nix
          ./tools/mpd.nix
          ./tools/task.nix
          ./secrets
          ./tools/python.nix
        ];
        home.stateVersion = "22.11";

        # set configuratble module options here
        modules.editors.nixCats.setDefault = lib.mkDefault true;
      };

      sync-services.imports = [./tools/syncthing.nix];

      gui.imports = [
        ./tools/fonts.nix
        ./terminals/kitty.nix
        ./browsers/firefox.nix
        ./prod/essentials.nix
        ./terminals/wezterm
        ./editors/neovide.nix
      ];

      wayland.imports = [
        ./wayland-shell/hyprland
        ./wayland-shell/wayper.nix
        ./wayland-shell/dunst.nix
        ./wayland-shell/rofi.nix
        ./wayland-shell/anyrun
        ./wayland-shell/waybar
        ./wayland-shell/ags
        ./wayland-shell/easyeffects.nix
      ];

      misc-gui.imports = [
        ./prod/school.nix
        ./games/general.nix
        ./tools/ticktick.nix
      ];

      gui-darwin.imports = [./terminals/kitty.nix ./tools/fonts.nix];

      # for specific systems

      luqman-asuna = {
        imports = [
          self.homeModules.common
          ./luqman-home.nix

          self.homeModules.gui
          self.homeModules.wayland
          self.homeModules.misc-gui

          ./editors/emacs
          ./editors/vscode.nix

          ./games/lutris.nix
          self.homeModules.sync-services
        ];
      };

      luqman-sinon = {
        imports = [
          self.homeModules.common
          ./luqman-home.nix

          ./tools/fonts.nix
          ./terminals/kitty.nix
        ];
      };

      luqman-fenrys = {
        imports = [self.homeModules.common ./luqman-home-fenrys.nix self.homeModules.gui-darwin];
        modules.terminals.kitty.fontSize = 12.0;
      };

      luqman-kurumi = {
        imports = [
          self.homeModules.common
          ./luqman-home.nix

          self.homeModules.gui
          self.homeModules.wayland
          self.homeModules.misc-gui

          ./editors/vscode.nix
        ];
      };

      luqman-alya = {
        imports = [
          ./luqman-home-alya.nix
          ./configopts.nix
          ./editors/lazyvim
          ./tools/shell.nix
          ./tools/starship.nix
          ./terminals/zellij.nix
          ./tools/task.nix
          ./secrets
          ./tools/python.nix
        ];

        programs.home-manager.enable = true;
        home.stateVersion = "22.11";
      };
    };
  };
}
