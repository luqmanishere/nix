{pkgs, ...}: {
  users.users.luqman = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = ["wheel" "audio" "video" "networkmanager" "podman" "adbusers" "mediacenter" "docker"];
    shell = pkgs.fish;
    hashedPassword = "$y$j9T$eP.N3NAlrWm2f8OHHG4FE.$iBzd8hkR0mERN1K4JkaAueK5NRfO5dXa.zZh7zX8PV/";
    createHome = true;
    description = "Luqmanul Hakim";
  };

  programs.fish.enable = true;

  security.sudo.extraRules = [
    {
      users = ["luqman"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
}
