{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [
      prismlauncher
      gamescope
      mangohud
      scrcpy
      discord
    ];
  };
}
