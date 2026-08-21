{inputs, ...}: {
  flake.modules.nixos.niri = {pkgs, ...}: {
    imports = [inputs.niri-flake.nixosModules.niri];

    environment.systemPackages = with pkgs; [
      nautilus
      adwaita-icon-theme
    ];

    programs.niri.enable = true;
    programs.niri.package = pkgs.niri;
    programs.dconf.enable = true;

    nixpkgs.overlays = [
      inputs.niri-flake.overlays.niri
    ];
  };

  flake.modules.homeManager.niri = {pkgs, ...}: {
    # NOTE: home manager module is auto imported by the nixos module
    # Mark this host as graphical so GUI-only packages (e.g. smudgy) load here.
    modules.core.gui = {
      enable = true;
      wmType = "wayland";
      wmName = "niri";
    };

    programs.niri = {
      # enable = true;
      config = builtins.readFile ./config.kdl;
      package = pkgs.niri;
    };

    services.shikane.enable = true;
  };
}
