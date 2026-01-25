{
  services.kea = {
    dhcp4.enable = true;
    dhcp4.settings = {
      interfaces-config.interfaces = ["enp3s0f3u2"];
      lease-database = {
        name = "/var/lib/kea/dhcp4.leases";
        persist = true;
        type = "memfile";
      };
      rebind-timer = 2000;
      renew-timer = 1000;
      subnet4 = [
        {
          id = 1;
          subnet = "192.0.2.0/24";
          pools = [
            {
              pool = "192.0.2.100 - 192.0.2.240";
            }
          ];
          option-data = [
            {
              name = "routers";
              data = "192.0.2.1";
            }
          ];
        }
      ];
      valid-lifetime = 4000;
    };
  };
}
