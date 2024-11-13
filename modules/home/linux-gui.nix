{
  imports = [
    # gui stuff
    ./all/tools/fonts.nix
    ./all/terminals/kitty.nix
    ./all/browsers/firefox.nix
    ./all/prod/essentials.nix
    ./all/terminals/wezterm
    ./all/editors/neovide.nix

    # wayland
    ./all/wayland-shell/hyprland
    ./all/wayland-shell/wayper.nix
    ./all/wayland-shell/dunst.nix
    ./all/wayland-shell/rofi.nix
    ./all/wayland-shell/anyrun
    ./all/wayland-shell/waybar
    ./all/wayland-shell/ags
    ./all/wayland-shell/easyeffects.nix

    # misc gui
    ./all/prod/school.nix
    ./all/games/general.nix
    ./all/tools/ticktick.nix

    ./all/editors/emacs
    ./all/editors/vscode.nix

    ./all/games/lutris.nix

    # sync-services
    ./all/tools/syncthing.nix
  ];
}
