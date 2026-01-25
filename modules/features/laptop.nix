{...}: {
  flake.modules.nixos.laptop = {
    services.upower.enable = true;
  };
}
