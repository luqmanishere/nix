{...}: {
  flake.modules.homeManager.sherlock = {
    # TODO: flesh out or integrate somewhere
    programs.sherlock.enable = true;
  };
}
