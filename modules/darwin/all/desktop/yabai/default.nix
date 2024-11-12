{
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {
      layout = "float";
      top_padding = 35;
      bottom_padding = 20;
      left_padding = 20;
      right_padding = 20;
      window_gap = 3;
    };
    extraConfig = ''
      yabai -m space 3 --layout bsp
      yabai -m rule --add app="^System Settings$" manage=off
      yabai -m rule --add app="^Calculator$" manage=off
      yabai -m rule --add app="^Karabiner-Element$" manage=off
      yabai -m rule --add app="^App Store$" manage=off
      yabai -m rule --add app="^Calendar$" manage=off
      yabai -m rule --add app="^Finder$" manage=off
      # yabai -m rule --add app="^Discord$" manage=off
    '';
  };
  services.skhd = {
    enable = true;
    skhdConfig = builtins.readFile ./skhdrc;
  };
}
