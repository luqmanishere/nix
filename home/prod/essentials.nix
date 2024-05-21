{pkgs, ...}: {
  home.packages = with pkgs; [
    tdesktop
    obsidian
    zathura
    whatsapp-for-linux
  ];
}
