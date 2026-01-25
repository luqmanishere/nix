{inputs, ...}: let
  hypridle = inputs.hypridle;
  hyprlock = inputs.hyprlock;
in {
  flake.modules.homeManager.hypridle = {pkgs, ...}: let
    suspendScript = pkgs.writeShellScript "suspend-script" ''
      ${pkgs.pipewire}/bin/pw-cli i all 2>&1 | ${pkgs.ripgrep}/bin/rg running -q
      # only suspend if audio isn't running
      if [ $? == 1 ]; then
        exit
        ${pkgs.systemd}/bin/systemctl suspend
      fi
    '';
    screen_off_cmd = "${pkgs.niri-stable}/bin/niri msg action power-off-monitors";
    screen_on_cmd = "${pkgs.niri-stable}/bin/niri msg action power-on-monitors";
    # screen_off_cmd = match {wmName = gui_config.wmName;} [
    #   [{wmName = "niri";} "${pkgs.niri-stable}/bin/niri msg action power-off-monitors"]
    #   [{wmName = "hyprland";} "${pkgs.hyprland}/bin/hyprctl dispatch dpms off"]
    # ];
    # screen_on_cmd = match {wmName = gui_config.wmName;} [
    #   [{wmName = "niri";} "${pkgs.niri-stable}/bin/niri msg action power-on-monitors"]
    #   [{wmName = "hyprland";} "${pkgs.hyprland}/bin/hyprctl dispatch dpms on"]
    # ];
  in {
    services.hypridle = {
      enable = true;
      package = hypridle.packages.${pkgs.system}.hypridle;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || ${hyprlock.packages.${pkgs.system}.hyprlock}/bin/hyprlock";
          unlockcmd = "killall -q -s SIGUSR1 hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "${screen_on_cmd}";
          ignore_dbus_inhibit = false;
        };
        listener = [
          # turn off screen after 5 minutes
          {
            timeout = 180;
            on-timeout = screen_off_cmd;
          }
          {
            timeout = 300;
            on-timeout = "pidof hyprlock || loginctl lock-session && ${screen_off_cmd}";
          }
          {
            timeout = 600;
            on-timeout = suspendScript.outPath;
          }
          {
            timeout = 15;
            on-timeout = "pidof hyprlock && ${screen_off_cmd}";
          }
          # TODO: options
          # (
          #   if cfg.keyboardLed.enable
          #   then {
          #     timeout = 60;
          #     on-timeout = "brightnessctl -sd '${cfg.keyboardLed.device}' set 0";
          #     on-resume = "brightnessctl -rd '${cfg.keyboardLed.device}'";
          #   }
          #   else null
          # )
        ];
      };
    };
  };
}
