{config, lib, pkgs, ...}:
lib.mkIf (config.everything.podman.enable) {
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    # waydroid.enable = true;
    # lxd.enable = true;
  };
  # environment.shellInit = ''
  #   [ -n "$DISPLAY" ] && xhost +si:localuser:$USER || true
  # '';
    

}
