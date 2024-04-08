{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [
      prismlauncher
      #inputs.prismlauncher.packages.${pkgs.system}.prismlauncher
      #osu-lazer
      gamescope
      mangohud
      scrcpy
    ];
  };
}
