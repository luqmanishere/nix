{config, ...}: {
  home = {
    username = "luqman";
    homeDirectory = "/Users/luqman";
    sessionVariables = {
      COLORTERM = "truecolor";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      MEOW = "cat";
    };
  };
}
