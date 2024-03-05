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
    # bootloader.enable = true;
    intel-hardware-acceleration.enable = true;
    # vpn = {
    #   enable = true;
    #   address = "10.1.1.2/24";
    # };
    podman.enable = true;
    mdns.enable = true;
    users.enei = {
      admin = true;
      shell = pkgs.fish;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
 
  hardware.trackpoint.enable = true;
  hardware.trackpoint.emulateWheel = true;

  networking.hostName = "t460"; # Define your hostname.

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
  programs.git.enable = true;

  nixpkgs.config.allowUnfree = true;

  services.flatpak.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 23567 23568 5173 ];
  networking.firewall.allowedUDPPorts = [ 23567 23568 5173 5353 ];
  networking.firewall.enable = true;

  networking.wireguard.interfaces = {
    mesh = {
      listenPort = 23568;
      ips = ["10.2.2.3/24"];

      privateKeyFile = "/home/enei/wireguard-keys/private";
    };
  };
  
  services.wgautomesh = {
    enable = true;
    openFirewall = true;
    enablePersistence = true;
    enableGossipEncryption = true;
    gossipSecretFile = "/home/enei/wireguard-keys/gossip";
    settings = {
      interface = "mesh";
      lan_discovery = true;
      peers = [
        {
          pubkey = "LYQSaUhHQuI/sr7FHdiZMP1UviDobEYjGxWRGjXni1U=";
          address = "10.2.2.1";
          endpoint = "zaanimivo.xyz:23568";
        }

        {
          pubkey = "48pSfQjFSFzNQ/aeLQQU39g6RzqId/fvp8Z82GzCZ0A=";
          address = "10.2.2.2";
          endpoint = "zaanimivo.xyz:23568";
        }

        {
          pubkey = "Pe2KUyql4rS459LSjWCLImVpWxkwS1jjXmRyw9IZSHw=";
          address = "10.2.2.4";
          endpoint = "zaanimivo.xyz:23568";
        }
      ];
    };
  };
  networking.hosts = {
    "10.2.2.1" = ["seymour"];
    "10.2.2.2" = ["kista"];
    "10.2.2.4" = ["predal"];
  };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
