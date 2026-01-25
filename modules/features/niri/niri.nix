{inputs, ...}: {
  flake.modules.nixos.niri = {pkgs, ...}: {
    imports = [inputs.niri-flake.nixosModules.niri];

    environment.systemPackages = with pkgs; [
      nautilus
      adwaita-icon-theme
    ];

    programs.niri.enable = true;
    programs.dconf.enable = true;

    nixpkgs.overlays = [
      inputs.niri-flake.overlays.niri
    ];
  };

  flake.modules.homeManager.niri = {...}: {
    # modules.core.gui = {
    #   enable = mkForce true;
    #   wmType = "wayland";
    #   wmName = "niri";
    # };

    # modules.wayland-shell.utils.enable = mkForce true;

    programs.niri = {
      # enable = true;
      config = builtins.readFile ./config.kdl;
    };

    services.shikane.enable = true;
  };
}
