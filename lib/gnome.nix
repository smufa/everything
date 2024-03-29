{config, pkgs, lib, ...}: 
lib.mkIf (config.everything.gnome.enable) {
  # Enable the GNOME Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Exclude default gnome packages
  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-tour
      gnome-text-editor
      gnome-console
      xterm
    ])
    ++ (with pkgs.gnome; [
      gnome-contacts
      epiphany # web browser
      geary # email reader
      tali # poker game
      hitori # sudoku game
      atomix # puzzle game
    ]);

  # Configure keymap in X11 (Not sure this does anything)
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Extra fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["SourceCodePro"];})
  ];

  # Enable uinput for emulated input devices
  hardware.uinput.enable = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages =
    (with pkgs; [
      papirus-icon-theme
      drawing
    ])
    ++ (with pkgs.gnome; [
      gnome-terminal
      gnome-tweaks
      gnome-settings-daemon
      ghex
    ])
    ++ (with pkgs.gnomeExtensions; [
      appindicator
      caffeine
    ]);
}
