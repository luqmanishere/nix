{
  imports = [
    ./all/nix-limits.nix
    ./all/users.nix
    ./all/groups.nix
    ./all/dev.nix
    ./all/shells.nix
    ./all/nh.nix
    ./all/power.nix
    ./all/polkit.nix
    ./all/services/avahi.nix
  ];

  modules.editors.nixCats.setDefault = true;
}
