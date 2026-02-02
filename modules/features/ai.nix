{...}: {
  flake.modules.homeManager.ai = {pkgs, ...}: {
    # claude code
    home.packages = with pkgs; [opencode codex];
    programs.claude-code.enable = true;
  };
}
