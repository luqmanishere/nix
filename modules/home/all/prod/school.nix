{pkgs, ...}: {
  config = {
    home = {
      packages = with pkgs; [
        #desktop apps
        # TODO: move these browsers into their own file
        chromium
        microsoft-edge
        foliate
        libreoffice
      ];
    };
  };
}
