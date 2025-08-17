{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [localsend];
  };
}
