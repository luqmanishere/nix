{...}: {
  flake.modules.homeManager.muds = {pkgs, ...}: {
    home.packages = with pkgs; [mudlet mudforge];
  };
}
