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
  ];

  modules.editors.nixCats.setDefault = true;
}
