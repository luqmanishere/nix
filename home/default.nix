{self, ...}: {
  flake = {
    homeModules = {
      # common modules that should be imported by everyone.
      # these modules should be usable in all environments
      common = {
        imports = [
          ./configopts.nix
          ./editors/astronvim
          ./tools/shell.nix
          ./tools/starship.nix
          ./terminals/zellij.nix
          ./tools/mpd.nix
          ./tools/task.nix
          ./secrets
        ];
        home.stateVersion = "22.11";
      };

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
      ];

      misc-gui.imports = [
        ./prod/school.nix
        ./games/general.nix
      ];

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
        imports = [self.homeModules.common ./luqman-home.nix];
      };
    };
  };
}
