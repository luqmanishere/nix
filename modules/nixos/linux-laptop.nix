{
  imports = [
    ./all/services/onepassword.nix
    ./all/services/avahi.nix
    ./all/login/tuigreet.nix
    ./all/login/hyprland.nix
    ./all/xdg.nix

    # ./all/games/steam.nix
    ./all/initrd.nix
    ./all/plymouth.nix
    # ./all/games/aagl.nix
    # ./all/experimental/protonvpn.nix
    # ./all/acpufreq.nix
    ./all/networking/networkd-iwd.nix
  ];
}
