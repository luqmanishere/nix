{pkgs, ...}: {
  config = {
    services.greetd = {
      enable = true;
      settings = {
        vt = 2;
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };
  };
}
