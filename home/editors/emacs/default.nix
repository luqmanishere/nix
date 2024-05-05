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

    home.file = {
      ".emacs.d/init.el".source = ./init.el;
      ".emacs.d/early-init.el".source = ./early-init.el;
      ".emacs.d/lisp".source = ./lisp;
    };
  };
}
