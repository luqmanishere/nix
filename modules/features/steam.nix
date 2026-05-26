{...}: {
  flake.modules.nixos.steam = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      mangohud
      protonplus
    ];

    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraArgs = "-system-composer";
      };

      extraPackages = with pkgs; [
        gamescope
        mangohud
        gamemode
      ];
    };
    programs = {
      gamescope = {
        enable = true;
        capSysNice = false;
      };
    };

    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;
  };
}
