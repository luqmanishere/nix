{config, ...}: {
  home = {
    username = "luqman";
    homeDirectory = "/home/luqman";
    sessionVariables = {
      COLORTERM = "truecolor";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      MEOW = "cat";
    };
  };

  xdg = {
    enable = true;
    userDirs.enable = true;
    configHome = "${config.home.homeDirectory}/.config";
  };
}
