{...}: {
  flake.modules.homeManager.dev-tools = {pkgs, ...}: {
    # TODO: proper feature
    home.packages = with pkgs; [dbeaver-bin nodejs bun];
  };
}
