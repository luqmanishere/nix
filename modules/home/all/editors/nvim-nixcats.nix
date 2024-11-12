{
  flake,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) nvim-nixcats;
  cfg = config.modules.editors.nixCats;
in {
  imports = [
    nvim-nixcats.homeModule
  ];
  options = with lib; {
    modules.editors.nixCats.setDefault = mkOption {
      default = false;
      description = "Set nixCats (alias: cats) as the default EDITOR";
      type = types.bool;
    };
  };
  config = {
    nixCats.enable = true;
    home.sessionVariables = lib.mkIf cfg.setDefault {EDITOR = "cats";};
  };
}
