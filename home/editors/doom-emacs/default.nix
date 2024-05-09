{pkgs, ...}: {
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
    };

    services.emacs.enable = true;
    services.emacs.package = pkgs.emacs29;

    # TODO: manage doom emacs files here once stable
  };
}
