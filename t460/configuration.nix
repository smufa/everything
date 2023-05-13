# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../lib/gnome.nix
      ../lib/space-optimization.nix
      ../lib/locale.nix
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
  # networking.hosts = {
  #   "192.168.64.69" = [ "malina" ];
  # };

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  #services.printing.drivers = [ pkgs.lpr pkgs.cupswrapper ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };
  programs.fish.enable = true;
  users.users.enei = {
    isNormalUser = true;
    description = "enei";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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
