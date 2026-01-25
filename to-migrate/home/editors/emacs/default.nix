{
  pkgs,
  config,
  lib,
  ...
}: let
  emacs-treesitter = pkgs.emacs29.pkgs.withPackages (epkgs:
    with epkgs; [
      astro-ts-mode
      treesit-grammars.with-all-grammars
    ]);
  cfg = config.modules.editors.emacs;
in {
  options.modules.editors.emacs = {
    enable = lib.mkEnableOption "Enable the Emacs editor";
  };

  config = lib.mkIf cfg.enable {
    # home.packages = with pkgs; [
    #   rust-analyzer
    #   fd
    #   ripgrep
    #   silver-searcher
    #   coreutils
    #   clang
    #   git
    # ];
    programs.emacs = {
      enable = true;
      package = pkgs.emacs;
      extraPackages = epkgs: [epkgs.treesit-grammars.with-all-grammars];
    };

    # services.emacs.enable = true;
    # services.emacs.package = pkgs.emacs29;

    # TODO: manage doom emacs files here once stable
  };
}
