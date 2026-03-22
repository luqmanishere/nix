{...}: {
  flake.modules.homeManager.emacs = {pkgs, ...}: {
    programs.emacs = {
      enable = true;
      # package = pkgs.emacs-pgtk;
      package = pkgs.emacs;
      extraPackages = epkgs: [epkgs.treesit-grammars.with-all-grammars];
    };
  };
}
