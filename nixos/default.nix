{
  self,
  inputs,
  lib,
  withSystem,
  ...
}: let
  inherit
    (inputs)
    disko
    home-manager
    ;

  mkNixosConfig = {
    system ? "x86_64-linux",
    nixpkgs ? inputs.nixpkgs,
    defaultUser ? "luqman",
    hardwareModules ? [],
    baseModules ? [
      home-manager.nixosModules.home-manager
      disko.nixosModules.disko
    ],
    hostModules ? [],
    homeManagerModules ? [],
    # TODO: go crazy and add an extra users module
  }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules =
        baseModules
        ++ hardwareModules
        ++ hostModules
        ++ [
          {
            home-manager = {
              useUserPackages = true;
              # extraSpecialArgs = {inherit inputs outputs;};
              extraSpecialArgs = {inherit inputs self;};
              users."${defaultUser}" = {
                imports = [] ++ homeManagerModules;
                programs.home-manager.enable = true;
                systemd.user.startServices = "sd-switch";
                home.stateVersion = "22.11";
              };
            };
          }
        ];
      specialArgs = {inherit self inputs lib;};
    };

  hosts = lib.rakeLeaves ./hosts;
  home-modules = lib.rakeLeaves ./modules/home-manager;
in {
  imports = [];

  flake.nixosConfigurations = {
    asuna = withSystem "x86_64-linux" ({...}:
      mkNixosConfig {
        hardwareModules = [];
        hostModules = [hosts.asuna];
        homeManagerModules = [
          home-modules.nix-config
          home-modules.luqman-home
          home-modules.secrets

          home-modules.browsers.firefox
          home-modules.editors.astronvim
          home-modules.games.general
          home-modules.prod.school
          home-modules.terminals.kitty
          home-modules.terminals.wezterm
          home-modules.terminals.zellij
          home-modules.tools.fonts
          home-modules.tools.mpd
          home-modules.tools.shell
          home-modules.tools.starship
          home-modules.tools.task
          home-modules.wayland-shell.dunst
          home-modules.wayland-shell.hyprland
          home-modules.wayland-shell.waybar
          home-modules.wayland-shell.wayper
          home-modules.wayland-shell.rofi
          home-modules.wayland-shell.anyrun
        ];
      });
  };
}
