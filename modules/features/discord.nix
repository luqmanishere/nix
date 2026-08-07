{inputs, ...}: {
  flake.modules.homeManager.discord = {pkgs, ...}: {
    imports = [
      inputs.nixcord.homeModules.nixcord
    ];

    programs.nixcord = {
      enable = true;

      discord.equicord.enable = true;
    };
  };
}
