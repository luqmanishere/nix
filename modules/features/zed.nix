{...}: {
  flake.modules.homeManager.zed = {pkgs, ...}: {
    programs.zed-editor = {
      enable = true;
      extraPackages = with pkgs; [
        nixd
        alejandra
      ];
    };
  };
}
