{config, lib, ...}: 
lib.mkIf (config.everything.slo-locale.enable){
  # Set your time zone.
  time.timeZone = "Europe/Ljubljana";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sl_SI.utf8";
    LC_IDENTIFICATION = "sl_SI.utf8";
    LC_MEASUREMENT = "sl_SI.utf8";
    LC_MONETARY = "sl_SI.utf8";
    LC_NAME = "sl_SI.utf8";
    LC_NUMERIC = "sl_SI.utf8";
    LC_PAPER = "sl_SI.utf8";
    LC_TELEPHONE = "sl_SI.utf8";
    LC_TIME = "sl_SI.utf8";
  };
}
