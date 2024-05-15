{pkgs, ...}: let
  emacs-treesitter = pkgs.emacs29.pkgs.withPackages (epkgs:
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
      package = pkgs.emacs29;
      extraPackages = epkgs: [epkgs.treesit-grammars.with-all-grammars];
    };

    # services.emacs.enable = true;
    # services.emacs.package = pkgs.emacs29;

    # TODO: manage doom emacs files here once stable
  };
}
