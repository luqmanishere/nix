{
  flake,
  config,
  lib,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) nvim-nixcats;
  cfg = config.modules.editors.nixCats;
in {
  imports = [nvim-nixcats.nixosModules.default];

  options = with lib; {
    modules.editors.nixCats.setDefault = mkOption {
      default = false;
      description = "Set nixCats (alias: cats) as the default EDITOR";
      type = types.bool;
    };
  };

  config = {
    nixCats.enable = true;
    environment.sessionVariables = lib.mkIf cfg.setDefault {EDITOR = "cats";};
  };
}
