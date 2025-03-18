{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.sound.easyeffects;
in {
  options.modules.sound.easyeffects = {enable = mkEnableOption "Enable easyeffects";};

  config = {services.easyeffects.enable = cfg.enable;};
}
