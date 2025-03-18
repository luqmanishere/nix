{lib, ...}:
with lib; {
  options.modules.core.gui = {
    enable = lib.mkEnableOption "Enable GUI modules";
    wmName = mkOption {
      description = "The window manager currently used.";
      type = types.enum ["hyprland" "niri"];
      default = null;
    };
    wmType = mkOption {
      description = "X11 or Wayland";
      type = types.enum ["x11" "wayland"];
      default = null;
    };
  };
}
