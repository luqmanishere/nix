{...}: {
  flake.modules.homeManager.emacs = {pkgs, ...}: {
    home.packages = with pkgs; [alejandra nil];
    programs.emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;
      extraPackages = epkgs:
        with epkgs; [
          treesit-grammars.with-all-grammars
          eca
          vterm
          # TODO: package libghostel
        ];
    };
    services.emacs = {
      enable = true;
      socketActivation.enable = true;
      client.enable = true;
    };
  };
}
