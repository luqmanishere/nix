{inputs, ...}: {
  flake.modules.homeManager.zen = {pkgs, ...}: {
    home.packages = [
      inputs.zen-browser.packages."${pkgs.system}".default
    ];
  };
}
