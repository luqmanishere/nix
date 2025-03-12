# common to MacOS and Linux
{
  imports = [
    ./all/shared/nix.nix
    ./all/shared/editors/nvim-nixcats.nix
    ./all/shells.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  modules.editors.nixCats.setDefault = true;
}
