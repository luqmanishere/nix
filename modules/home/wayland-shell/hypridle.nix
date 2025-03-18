{
  flake,
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  inherit (flake) inputs;
  inherit (inputs) hypridle hyprlock;
  gui_config = config.modules.core.gui;

  if_let = v: p:
    if lib.attrsets.matchAttrs p v
    then v
    else null;
  match = v: l: builtins.elemAt (lib.lists.findFirst (x: (if_let v (builtins.elemAt x 0)) != null) null l) 1;

  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.pipewire}/bin/pw-cli i all 2>&1 | ${pkgs.ripgrep}/bin/rg running -q
    # only suspend if audio isn't running
    if [ $? == 1 ]; then
      exit
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';
  screen_off_cmd = match {wmName = gui_config.wmName;} [
    [{wmName = "niri";} "${pkgs.niri-stable}/bin/niri msg action power-off-monitors"]
    [{wmName = "hyprland";} "${pkgs.hyprland}/bin/hyprctl dispatch dpms off"]
  ];

  cfg = config.modules.wayland-shell.hypridle;
in {
  options.modules.wayland-shell.hypridle = {
    enable = mkEnableOption "Enable the hypridle daemon";
  };

  config = mkIf cfg.enable {
    services.hypridle = {
      enable = true;
      package = hypridle.packages.${pkgs.system}.hypridle;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || ${hyprlock.packages.${pkgs.system}.hyprlock}/bin/hyprlock";
          unlockcmd = "killall -q -s SIGUSR1 hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "${screen_off_cmd}";
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
        ];
      };
    };
    assertions = [
      {
        assertion = gui_config.enable;
        message = "a graphical wayland environment is required";
      }
      {
        assertion = gui_config.wmType == "wayland";
        message = "a wayland environment is required";
      }
    ];
  };
}
