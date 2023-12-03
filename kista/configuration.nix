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
    nvidia-hardware-acceleration.enable = true;
    # vpn.enable = true;
    podman.enable = true;
    mdns.enable = true;
    # users.enei = {
    #   admin = true;
    #   shell = pkgs.fish;
    # };
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="input", ATTRS{name}=="PC Speaker", ENV{DEVNAME}!="", TAG+="uaccess"
  '';
  environment.systemPackages = with pkgs; [
    beep
  ];
  # boot.initrd.kernelModules = [ "nvidia" ];
  # boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

  # Extend life of SSD
  services.fstrim.enable = true;
  services.fwupd.enable = true;

  networking.hostName = "kista"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # networking.networkmanager.unmanaged = ["enp6s0" "wlp7s0"];
  # networking = {
  #   wireless = {
  #     enable = true;
  #     networks.LANdalf.psk = "INNBOX3130305000979";
  #     interfaces = ["wlp7s0"];
  #   };
  #   interfaces = {
  #     enp6s0 = {
  #       ipv4.addresses = [
  #         {
  #           address = "84.255.199.103";
  #           prefixLength = 18;
  #         }
  #       ];
  #     };
  #     wlp7s0 = {
  #       ipv4.addresses = [
  #         {
  #           address = "192.168.64.69";
  #           prefixLength = 24;
  #         }
  #       ];
  #       ipv4.routes = [
  #         {
  #           address = "192.168.64.0";
  #           prefixLength = 24;
  #           via = "192.168.64.1";
  #         }
  #       ];
  #     };
  #   };
  #   defaultGateway = "84.255.192.1";
  #   nameservers = ["84.255.209.79"];
  # };

  networking.wireguard.interfaces = {
    here = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ "10.1.1.3/24" ];
      listenPort = 23567; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/home/enei/wireguard-keys/private";

      peers = [
        # For a client configuration, one peer entry for the server will suffice.

        {
          # Public key of the server (not a file path).
          publicKey = "LYQSaUhHQuI/sr7FHdiZMP1UviDobEYjGxWRGjXni1U=";

          allowedIPs = [ "10.1.1.0/24" ];

          # Set this to the server IP and port.
          endpoint = "192.168.64.69:23567"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
          # endpoint = "84.255.199.103:23567"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
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
  users.users = {
    enei = {
      isNormalUser = true;
      description = "Enei";
      extraGroups = ["networkmanager" "wheel" "uinput" "input"];
      shell = pkgs.fish;
      packages = with pkgs; [
        firefox-wayland
        ungoogled-chromium
        epiphany
        #  thunderbird
      ];
    };
    tina = {
      isNormalUser = true;
      description = "Tina";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.fish;
      packages = with pkgs; [
        firefox
        #  thunderbird
      ];
    };
  };

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
