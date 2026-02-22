{...}: {
  flake.modules.homeManager.productivity = {pkgs, ...}: {
    home.packages = with pkgs; [
      obsidian
      zathura
      anytype
      # disabled due to pnpm deps thing
      # self.packages.${pkgs.system}.siyuan-unlock
    ];
  };
}
