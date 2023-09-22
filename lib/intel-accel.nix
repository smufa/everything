{config, lib, pkgs, ...}:
lib.mkIf (config.everything.intel-hardware-acceleration.enable) {
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
