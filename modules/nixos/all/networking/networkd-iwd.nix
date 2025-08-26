_: {
  options = {};
  config = {
    # TODO: modularize this
    systemd.network = {
      enable = true;
      wait-online.anyInterface = true;

      networks."10-wireless" = {
        matchConfig.Name = "wl*";
        networkConfig = {
          DHCP = "ipv4";
          DNS = ["1.1.1.1" "8.8.8.8"];
          MulticastDNS = "yes";
          IPv6AcceptRA = "no";
        };
        linkConfig = {
          RequiredForOnline = "no";
          Multicast = "yes";
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
