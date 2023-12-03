{config, lib, pkgs, ...}:
lib.mkIf (config.everything.beep.enable) {
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="input", ATTRS{name}=="PC Speaker", ENV{DEVNAME}!="", TAG+="uaccess"
  '';
  environment.systemPackages = with pkgs; [
    beep
  ];
}
