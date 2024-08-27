{pkgs, ...}: {
  users.users.luqman = {
    # extraGroups = ["wheel" "audio" "video" "networkmanager" "podman" "adbusers" "mediacenter"];
    shell = pkgs.fish;
    createHome = true;
  };

  programs.fish.enable = true;
}
