{...}: {
  flake.modules.homeManager.chromium = {
    programs.chromium.enable = true;
  };
}
