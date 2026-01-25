{pkgs, ...}: {
  users.users.luqman = {
    # extraGroups = ["wheel" "audio" "video" "networkmanager" "podman" "adbusers" "mediacenter"];
    shell = pkgs.fish;
    createHome = true;
  };

  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    if test -d (brew --prefix)"/share/fish/completions"
      set -p fish_complete_path (brew --prefix)/share/fish/completions
    end

    if test -d (brew --prefix)"/share/fish/vendor_completions.d"
        set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end
  '';
}
