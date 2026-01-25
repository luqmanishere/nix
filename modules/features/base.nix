# defaults for all
{...}: {
  flake.modules = {
    nixos.base = {
      lib,
      pkgs,
      ...
    }: {
      time.timeZone = "Asia/Kuala_Lumpur";
      i18n.defaultLocale = "en_US.UTF-8";

      # base packages
      environment.systemPackages = with pkgs; [
        vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        wget
        neovim
        tmux
        git
        curl
        bash
        jq
      ];

      programs.nh = {enable = true;};

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      system.stateVersion = lib.mkDefault "25.05";
    };
    homeManager.base = {
      config,
      lib,
      ...
    }: {
      home.sessionVariables = {
        # TODO: are these necessary?
        # username = "luqman";
        # homeDirectory = "/home/luqman";
        COLORTERM = "truecolor";
        XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
        MEOW = "cat";
      };

      xdg = {
        enable = true;
        userDirs.enable = true;
        configHome = "${config.home.homeDirectory}/.config";
      };

      home.stateVersion = lib.mkDefault "22.11";
    };
  };
}
