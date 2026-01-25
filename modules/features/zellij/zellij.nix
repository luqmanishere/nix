{...}: {
  flake.modules.homeManager.zellij = {lib, ...}: {
    programs.zellij = {
      enable = true;
      enableFishIntegration = lib.mkForce false;
    };

    xdg.configFile."zellij/config.kdl".source = ./config.kdl;
    xdg.configFile."zellij/layouts/default.kdl".source = ./layouts/default.kdl;
  };
}
