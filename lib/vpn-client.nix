{config, lib, pkgs, ...}:
lib.mkIf (config.everything.vpn.enable) {
  networking.wireguard.interfaces = {
    siska = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ config.everything.vpn.address ];
      listenPort = 23567; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = toString config.everything.vpn.private-key;

      peers = [
        # For a client configuration, one peer entry for the server will suffice.

        {
          # Public key of the server (not a file path).
          publicKey = "LYQSaUhHQuI/sr7FHdiZMP1UviDobEYjGxWRGjXni1U=";

          allowedIPs = [ "10.1.1.0/24" ];

          # Set this to the server IP and port.
          endpoint = "84.255.199.103:23567"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
