# from: https://discourse.nixos.org/t/nixos-access-point-via-hostapd/1060/5
{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.solemnattic.modules.system.wifi-relay;
in {
  options.solemnattic.modules.system.wifi-relay = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Wi-Fi relay on the same card.";
    };

    network-interface = mkOption {
      # change to str because idk wth was it orignally
      # type = types.enum devices.network-interface;
      type = types.str;
      description = "Wi-Fi network interface to use";
    };

    dns = mkOption {
      default = "192.168.12.1";
      type = types.str;
      description = "DNS address to advertise through DHCP";
      example = "192.168.12.1, 8.8.8.8, 1.1.1.1";
    };
  };

  config = mkIf (cfg.enable) {
    # "wlan-station0" is for wifi-client managed by network manager, "wlan-ap0" is for hostap
    networking.wlanInterfaces = {
      "wlan-station0" = {device = cfg.network-interface;};
      "wlan-ap0" = {
        device = cfg.network-interface;
        mac = "08:11:96:0e:08:0a";
      };
    };

    networking.networkmanager.unmanaged = ["interface-name:${cfg.network-interface}" "interface-name:wlan-ap0"];

    services.hostapd = {
      enable = true;
      radios."wlan-ap0" = {
        band = "2g";
        networks."wlan-ap0" = {
          authentication = {
            mode = "wpa2-sha256";
            wpaPassword = "@@@@@@@@";
          };
          ssid = "Ayaya";
        };
      };
    };

    networking.interfaces."wlan-ap0".ipv4.addresses = [
      {
        address = "192.168.12.1";
        prefixLength = 24;
      }
    ];

    # services.dhcpd4 = {
    #   enable = true;
    #   interfaces = ["wlan-ap0"];
    #   extraConfig = ''
    #     option subnet-mask 255.255.255.0;
    #     option broadcast-address 192.168.12.255;
    #     option routers 192.168.12.1;
    #     option domain-name-servers ${cfg.dns};
    #     subnet 192.168.12.0 netmask 255.255.255.0 {
    #       range 192.168.12.100 192.168.12.200;
    #     }
    #   '';
    # };
    networking.firewall.allowedUDPPorts = [53 67]; # DNS & DHCP
    services.haveged.enable =
      config.services.hostapd.enable; # Sometimes slow connection speeds are attributed to absence of haveged.

    boot.kernel.sysctl."net.ipv4.ip_forward" = 1; # Enable package forwarding.

    systemd.services.wifi-relay = let
      inherit (pkgs) iptables gnugrep;
    in {
      description = "iptables rules for wifi-relay";
      after = ["dhcpd4.service"];
      wantedBy = ["multi-user.target"];
      script = ''
        ${iptables}/bin/iptables -w -t nat -I POSTROUTING -s 192.168.12.0/24 ! -o wlan-ap0 -j MASQUERADE
        ${iptables}/bin/iptables -w -I FORWARD -i wlan-ap0 -s 192.168.12.0/24 -j ACCEPT
        ${iptables}/bin/iptables -w -I FORWARD -i wlan-station0 -d 192.168.12.0/24 -j ACCEPT
      '';
    };
  };
}
