{inputs, ...}: let
in {
  flake.modules.homeManager.ai = {pkgs, ...}: {
    # claude code
    home.packages = with pkgs; [
      opencode
      codex
      codex-acp
      # editor code assistant
      inputs.eca.packages.${pkgs.stdenv.hostPlatform.system}.eca
      # inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
    ];
    programs.claude-code.enable = true;
  };
}
