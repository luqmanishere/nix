{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.anyrun.homeManagerModules.default];
  config = {
    programs.anyrun = {
      enable = true;
      config = {
        plugins = [
          inputs.anyrun.packages.${pkgs.system}.applications
          inputs.anyrun.packages.${pkgs.system}.symbols
          inputs.anyrun.packages.${pkgs.system}.rink
          inputs.anyrun.packages.${pkgs.system}.shell
          inputs.anyrun.packages.${pkgs.system}.translate
        ];
        width = {absolute = 800;};
        x = {fraction = 0.5;};
        y = {absolute = 200;};
        hideIcons = false;
        ignoreExclusiveZones = false;
        hidePluginInfo = false;
        layer = "overlay";
        closeOnClick = false;
        showResultsImmediately = false;
        maxEntries = null;
      };
      extraCss = builtins.readFile ./style.css;
    };
  };
}
