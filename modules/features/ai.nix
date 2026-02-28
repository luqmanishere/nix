{inputs, ...}: let
in {
  flake.modules.homeManager.ai = {pkgs, ...}: {
    # claude code
    home.packages = with pkgs; [opencode inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex];
    programs.claude-code.enable = true;
  };
}
