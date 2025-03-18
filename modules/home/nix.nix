{pkgs, ...}: {
  config = {
    # Garbage collect automatically every week
    nix.gc.automatic = true;
    nix.package = pkgs.nixVersions.latest;
  };
}
