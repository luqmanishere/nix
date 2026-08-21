{inputs, ...}: {
  flake.modules.homeManager.quickshell = {
    lib,
    pkgs,
    ...
  }: let
    package = inputs.quickshell.packages.${pkgs.system}.default;
    caelestia = inputs.caelestia-niri;
  in
    with lib; {
      # Use caelestia's home-manager module to run the caelestia shell (which wraps
      # quickshell) instead of starting bare quickshell. The old manual setup is
      # kept below for reference.
      imports = [caelestia.homeManagerModules.default];

      programs.caelestia = {
        enable = true;
        systemd = {
          enable = true;
        };
        cli.enable = true;
        # config generation intentionally skipped for now - keep manual shell.json/cli.json
      };

      qt.enable = true;

      # Make Qt resolve freedesktop/SNI icon names (tray icons, app icons).
      # Without an icon theme Qt falls back to hicolor (empty) and every
      # System Tray icon lookup fails. Papirus ships a very complete
      # freedesktop set (both color and symbolic variants, incl. names Adwaita
      # lacks like network-connect / window-close); Papirus-Dark matches the
      # dark shell. The gtk3 platform theme makes Qt read gtk-icon-theme-name.
      qt.platformTheme.name = "gtk3";

      gtk = {
        enable = true;
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };
      };

      # --- Old manual quickshell setup (commented) ---
      # home.packages = with pkgs; [
      #   package
      #   pkgs.kdePackages.qtdeclarative
      #
      #   material-symbols
      # ];
      # qt.enable = true;
      #
      # systemd.user.services.quickshell = {
      #   Unit = {
      #     Description = "Quickshell custom shell";
      #     After = ["graphical-session.target"];
      #   };
      #
      #   Service = {
      #     ExecStart = "${getExe package}";
      #     Restart = "on-failure";
      #     RestartSec = 3;
      #   };
      #
      #   Install = {
      #     WantedBy = ["default.target"];
      #   };
      # };
    };
}
