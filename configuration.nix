# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-1d703e15-9079-4c06-a91f-83713d60fd2f".device = "/dev/disk/by-uuid/1d703e15-9079-4c06-a91f-83713d60fd2f";
  boot.initrd.luks.devices."luks-1d703e15-9079-4c06-a91f-83713d60fd2f".keyFile = "/crypto_keyfile.bin";

  virtualisation = {
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
    # waydroid.enable = true;
    # lxd.enable = true;
  };

  networking.hostName = "t460"; # Define your hostname.
  networking.hosts = {
    "192.168.64.69" = [ "malina" ];
  };

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Enable the GNOME Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Exclude default gnome packages
  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    gedit # text editor
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

  # Enable CUPS to print documents.
  services.printing.enable = true;
  #services.printing.drivers = [ pkgs.lpr pkgs.cupswrapper ];

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.enei = {
    isNormalUser = true;
    description = "enei";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.nushell;
    packages = with pkgs; [
    #  thunderbird
    ];
  };
  # home-manager.users.enei = {
  #   # programs.neovim = {
  #   #   enable = true;
  #   #   plugins = [
  #   #     pkgs.vimPlugins.conjure
  #   #     pkgs.vimPlugins.rainbow
  #   #   ];
  #   # };
  #   home.stateVersion = "22.11";
  # };
  
  # Enable fish
  programs.fish = {
    enable = true;
    shellAbbrs = {
      l = "exa --icons";
      ll = "exa --icons --long --header --git --no-user";
      lh = "exa --icons --long --header --git --all";
      lll = "exa --icons --tree --level=3 --header --git";
      llh = "exa --icons --tree --level=3 --header --git --all --long";
    };
  };
  programs.starship.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = (with pkgs; [
    exa
    bat
    ripgrep
    papirus-icon-theme
    distrobox
    git
    ntfs3g
  ]) ++ (with pkgs.gnome; [
    gnome-terminal
    gnome-tweaks
    gnome-settings-daemon    
    ghex
  ]) ++ (with pkgs.gnomeExtensions; [
    appindicator
  ]);
  
  # Extra fonts
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
  ];
  
  # Enable uinput for emulated input devices
  hardware.uinput.enable = true;
  
  # Storage optimization and general nix settings
  nix = {
    registry.nixpkgs.flake = nixpkgs;
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable flatpak
  services.flatpak.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 80 8080 4173 3000 ];
  # networking.firewall.allowedUDPPorts = [ 80 8080 4173 3000 ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
