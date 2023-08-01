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
    ../lib/gnome.nix
    ../lib/space-optimization.nix
    ../lib/locale.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="input", ATTRS{name}=="PC Speaker", ENV{DEVNAME}!="", TAG+="uaccess"
  '';
  environment.systemPackages = with pkgs; [
    beep
    # xhost
  ];
  
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  
  hardware.trackpoint.enable = true;
  hardware.trackpoint.emulateWheel = true;

  # environment.shellInit = ''
  #   [ -n "$DISPLAY" ] && xhost +si:localuser:$USER || true
  # '';

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
    "192.168.64.69" = [ "seymour" ];
  };

  # Enable networking
  networking.networkmanager.enable = true;
  
  networking.wireguard.interfaces = {
    siska = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ "10.1.1.2/24" ];
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
          endpoint = "84.255.199.103:23567"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  #services.printing.drivers = [ pkgs.lpr pkgs.cupswrapper ];
  
  # Extend life of SSD
  services.fstrim.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };
  programs.fish.enable = true;
  users.users.enei = {
    isNormalUser = true;
    description = "enei";
    extraGroups = ["networkmanager" "wheel" "uinput" "input"];
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
  networking.firewall.allowedTCPPorts = [ 23567 ];
  networking.firewall.allowedUDPPorts = [ 23567 ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
