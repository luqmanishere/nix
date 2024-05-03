{pkgs, ...}: {
  config = let
    emacs-pkg = pkgs.emacsWithPackagesFromUsePackage {
      config = ./init.el;
      package = pkgs.emacs-pgtk;
      alwaysEnsure = true;
    };
  in {
    home.packages = with pkgs; [rust-analyzer fd ripgrep silver-searcher];
    programs.emacs = {
      enable = true;
      package = emacs-pkg;
    };

    services.emacs.enable = true;
    services.emacs.package = emacs-pkg;
  };
}
