{...}: {
  flake.modules.nixos.networking = {lib, ...}: {
    networking.enableIPv6 = false;
    systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
    networking.wireguard.enable = true;
    services.tailscale.enable = true;
    services.tailscale.useRoutingFeatures = "client";

    networking.firewall.enable = lib.mkDefault false;

    # TODO: explore wireless flake option

    services.resolved = {
      enable = true;
      dnsovertls = "true";
      fallbackDns = [
        "1.1.1.1#cloudflare-dns.com"
        "1.0.0.1#cloudflare-dns.com"
        "9.9.9.9#dns.quad9.net"
      ];
    };

    systemd.network = {
      enable = true;
      wait-online.anyInterface = true;

      networks."10-wireless" = {
        matchConfig.Name = "wl*";
        networkConfig = {
          DHCP = "ipv4";
          DNS = [
            "1.1.1.1#cloudflare-dns.com"
            "1.0.0.1#cloudflare-dns.com"
          ];
          MulticastDNS = "yes";
          IPv6AcceptRA = "no";
        };
        linkConfig = {
          RequiredForOnline = "no";
          Multicast = "yes";
        };
        dhcpV4Config = {UseDNS = false;};
      };

      networks."30-tethering" = {
        matchConfig.name = "enp0s20f0u1c4i2";

        networkConfig = {
          DHCP = "ipv4";
          DNS = [
            "1.1.1.1#cloudflare-dns.com"
            "1.0.0.1#cloudflare-dns.com"
          ];
          MulticastDNS = "yes";
          IPv6AcceptRA = "no";
        };
        dhcpV4Config = {UseDNS = false;};
      };
    };

    # TODO: when nixos finally adds an iwd module use it
    networking.wireless.iwd = {
      enable = true;
      settings = {
        General = {EnableNetworkConfiguration = false;};
        Settings = {AutoConnect = true;};
        DriverQuirks = {UseDefaultInterface = true;};
      };
    };
  };
}
