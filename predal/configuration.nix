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
    nvidia-hardware-acceleration.enable = true;
    # vpn = {
    #   enable = true;
    #   address = "10.1.1.3/24";
    # };
    gamestream.enable = true;
    podman.enable = true;
    users.enei = {
      admin = true;
      shell = pkgs.fish;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.kernelPackages = pkgs.linuxPackages_zen;
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="input", ATTRS{name}=="PC Speaker", ENV{DEVNAME}!="", TAG+="uaccess"
  '';

  environment.systemPackages = with pkgs; [
    beep
    yuzu
  ];
  # boot.initrd.kernelModules = [ "nvidia" ];
  # boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
  # virtualisation.oci-containers.backend = "podman";
  # virtualisation.docker.enableNvidia = true;
  # systemd.enableUnifiedCgroupHierarchy = false;
  # virtualisation.oci-containers.containers = {
  #   lan = {
  #     image = "hello-world";
  #     autoStart = true;
  #     ports = [ "127.0.0.1:22:2664" ];
  #   };
  # };

  # Extend life of SSD
  services.fstrim.enable = true;
  services.fwupd.enable = true;

  networking.hostName = "predal"; # Define your hostname.
  services.logind.lidSwitch = "ignore";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.wireguard.interfaces = {
    mesh = {
      listenPort = 23568;
      ips = ["10.2.2.4/24"];

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
          endpoint = "84.255.199.103:23568";
        }

        {
          pubkey = "KwVT9IJWpvU/qg0LAe23BcLw4IJ8efeJS7xJ0ijhkxQ=";
          address = "10.2.2.3";
          endpoint = "zaanimivo.xyz:23568";
        }
      ];
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };
  programs.fish.enable = true;
  programs.git.enable = true;

  services.xserver.displayManager.gdm.autoSuspend = false;

  # Enable flatpak
  services.flatpak.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
