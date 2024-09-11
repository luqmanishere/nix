{
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {
      layout = "float";
      top_padding = 20;
      bottom_padding = 20;
      left_padding = 20;
      right_padding = 20;
    };
  };
  services.skhd = {
    enable = true;
    skhdConfig = builtins.readFile ./skhdrc;
  };
}
