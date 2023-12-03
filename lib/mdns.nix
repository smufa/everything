{config, lib, pkgs, ...}:
lib.mkIf (config.everything.mdns.enable) {
  # services.avahi = {
  #   nssmdns = true;
  #   enable = true;
  #   ipv4 = true;
  #   ipv6 = true;
  #   publish = {
  #     enable = true;
  #     addresses = true;
  #   };
  # };
  # use resolved for hostname resolution
  services.resolved.enable = true;

  # enable mdns resolution for resolved on all connections
  # see https://man.archlinux.org/man/NetworkManager.conf.5#CONNECTION_SECTION
  networking.networkmanager.connectionConfig."connection.mdns" = 2;
  # services.avahi.enable = true;
}
