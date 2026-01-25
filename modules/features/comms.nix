{...}: {
  flake.modules.homeManager.comms = {pkgs, ...}: {
    home.packages = with pkgs; [
      telegram-desktop
      zapzap
      (
        if system == "aarch64-linux"
        then vesktop # there is no aarch64_linux discord
        else discord
      )
      teams-for-linux
    ];
  };
}
