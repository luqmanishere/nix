{...}: {
  flake.modules.nixos.containers = {pkgs, ...}: {
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        defaultNetwork.settings = {dns_enabled = true;};
      };
    };

    environment.systemPackages = with pkgs; [dive podman-tui podman-compose];
  };
}
