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

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.enei = {
    isNormalUser = true;
    description = "enei";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };

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

  # Nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.powerManagement.enable = true;

  # Enable flatpak
  services.flatpak.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
