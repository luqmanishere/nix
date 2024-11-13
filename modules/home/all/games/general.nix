{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [
      prismlauncher
      gamescope
      mangohud
      scrcpy
      (discord.override {withVencord = true;})
    ];
  };
}
