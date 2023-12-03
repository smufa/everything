{config, lib, pkgs, ...}:
lib.mkIf (config.everything.mdns.enable) {
  services.avahi = {
    nssmdns = true;
    enable = true;
    ipv4 = true;
    ipv6 = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };
}
