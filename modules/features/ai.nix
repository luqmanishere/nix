{...}: {
  flake.modules.homeManager.ai = {pkgs, ...}: {
    # claude code
    home.packages = with pkgs; [opencode];
    programs.claude-code.enable = true;
  };
}
