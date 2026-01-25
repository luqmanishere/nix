{...}: {
  flake.modules.homeManager.wayland-utils = {pkgs, ...}: {
    home.packages = with pkgs; [
      cliphist
      wl-clipboard
      wlr-randr
      pavucontrol
      brightnessctl
    ];
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 22;
    };
  };
}
