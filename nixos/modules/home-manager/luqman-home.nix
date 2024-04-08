{config, ...}: {
  config = {
    home = {
      username = "luqman";
      homeDirectory = "/home/luqman";
      sessionVariables = {
        COLORTERM = "truecolor";
        XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
        MEOW = "cat";
      };
    };
    xdg.userDirs.enable = true;
    xdg.enable = true;
    xdg.configHome = "${config.home.homeDirectory}/.config";
  };
}
