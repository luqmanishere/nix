{lib, ...}: {
  # TODO: options to be used in the future
  options.modules.core.gui.enable = lib.mkEnableOption "Enable GUI modules";
}
