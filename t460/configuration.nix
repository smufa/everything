# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  
  everything = {
    gnome.enable = true;
    space-optimization.enable = true; 
    slo-locale.enable = true;
    bootloader.enable = true;
    intel-hardware-acceleration.enable = true;
    vpn.enable = true;
    podman.enable = true;
    users.enei = {
      admin = true;
      shell = pkgs.fish;
    };
  };
 
  hardware.trackpoint.enable = true;
  hardware.trackpoint.emulateWheel = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-1d703e15-9079-4c06-a91f-83713d60fd2f".device = "/dev/disk/by-uuid/1d703e15-9079-4c06-a91f-83713d60fd2f";
  boot.initrd.luks.devices."luks-1d703e15-9079-4c06-a91f-83713d60fd2f".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "t460"; # Define your hostname.
  networking.hosts = {
    "192.168.64.69" = [ "seymour" ];
  };

  # Enable networking
  networking.networkmanager.enable = true;  

  services.printing.enable = true;
  
  # Extend SSD lifetime
  services.fstrim.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };
  programs.fish.enable = true;

  nixpkgs.config.allowUnfree = true;

  services.flatpak.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 23567 ];
  networking.firewall.allowedUDPPorts = [ 23567 ];
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
