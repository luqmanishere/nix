{...}: {
  flake.modules.homeManager.emacs = {pkgs, ...}: {
    programs.emacs = {
      enable = true;
      # package = pkgs.emacs-pgtk;
      package = pkgs.emacs-pgtk;
      extraPackages = epkgs: with epkgs; [treesit-grammars.with-all-grammars eca];
    };
    services.emacs = {
      enable = true;
      socketActivation.enable = true;
      client.enable = true;
    };
  };
}
