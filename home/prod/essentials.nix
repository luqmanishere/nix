{pkgs, ...}: {
  home.packages = with pkgs; [
    tdesktop
    obsidian
    zathura
  ];
}
