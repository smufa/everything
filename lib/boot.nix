{config, lib, pkgs, ...}:
lib.mkIf (config.everything.bootloader.enable) {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
}
