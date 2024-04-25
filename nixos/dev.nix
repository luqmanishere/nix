{pkgs, ...}: {
  programs.direnv.enable = true;

  environment.systemPackages = with pkgs; [cachix];

  systemd.tmpfiles.rules = [
    "L+ /lib/${builtins.baseNameOf pkgs.stdenv.cc.bintools.dynamicLinker} - - - - ${pkgs.stdenv.cc.bintools.dynamicLinker}"
    "L+ /lib64 - - - - /lib"
  ];
}
