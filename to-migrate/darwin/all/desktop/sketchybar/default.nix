{pkgs, ...}: {
  environment.systemPackages = with pkgs; [sketchybar];
}
