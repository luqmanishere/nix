{pkgs, ...}: {
  config = {
    home = {
      packages = with pkgs; [
        #desktop apps
        tdesktop
        # TODO: move these browsers into their own file
        chromium
        microsoft-edge
        pavucontrol
        obsidian
        zathura
        foliate
        libreoffice
        logseq

        discord
      ];
    };
  };
}
