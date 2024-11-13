{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) auto-cpufreq;
in {
  imports = [auto-cpufreq.nixosModules.default];
  config = {
    programs.auto-cpufreq.enable = true;
    # optionally, you can configure your auto-cpufreq settings, if you have any
    programs.auto-cpufreq.settings = {
      charger = {
        governor = "performance";
        turbo = "auto";
      };

      battery = {
        governor = "powersave";
        turbo = "auto";
      };
    };
  };
}
