{pkgs, ...}: let
  emacs-treesitter = (pkgs.emacsPackagesFor pkgs.emacs29).emacsWithPackages (epkgs:
    with epkgs; [
      astro-ts-mode
      treesit-grammars.with-all-grammars
    ]);
in {
  config = {
    home.packages = with pkgs; [
      rust-analyzer
      fd
      ripgrep
      silver-searcher
      coreutils
      clang
      git
    ];
    programs.emacs = {
      enable = true;
      package = emacs-treesitter;
    };

    # services.emacs.enable = true;
    # services.emacs.package = pkgs.emacs29;

    # TODO: manage doom emacs files here once stable
  };
}
