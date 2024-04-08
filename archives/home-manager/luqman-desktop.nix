{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default
    ./modules
    ./nvim/lazyvim-nvim.nix
    ./graphical.nix
    ./emacs.nix
    ./mpd.nix
    ./syncthing.nix
    ./modules/tools/oci.nix
    ./neomutt.nix
    ./modules/editors/astronvim/astronvim.nix
    ./modules/terminals/zellij.nix
    outputs.homeManagerModules.a2ln
    inputs.nix-doom-emacs.hmModule
  ];

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    starship
    fish

    git
    delta
    age

    # FIXME: seperate cli, desktop profiles
    fzf
    ripgrep
    fd
    bat
    helix
    keychain
    tmux
    discord
  ];

  dunst.enable = true;
  rofi.enable = true;
  services.a2ln.enable = true;
  mpd.enable = true;
  syncthing.enable = true;
  neomutt.enable = true;

  modules.tools.oci-script.enable = true;

  modules.editors.emacs = {
    enable = false;
    # doom.enable = false;
    doom.doomConfigFiles = ./doom-emacs;
  };

  /*
  xdg = {
    mime.enable = true;
    mimeApps = {
      enable = true;
    };
  };
  */
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
