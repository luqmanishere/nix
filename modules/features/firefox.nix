{...}: {
  flake.modules.homeManager.firefox = {
    programs.firefox = {
      enable = true;
      profiles."solemnattic" = {
        name = "solemnattic";
        isDefault = true;
      };
    };
  };
}
