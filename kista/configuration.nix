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
  ];

  # Extend life of SSD
  services.fstrim.enable = true;

  networking.hostName = "kista"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };
  programs.fish.enable = true;
  users.users = {
    enei = {
      isNormalUser = true;
      description = "enei";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.fish;
      packages = with pkgs; [
        firefox
        ungoogled-chromium
        #  thunderbird
      ];
    };
    tina = {
      isNormalUser = true;
      description = "enei";
      extraGroups = ["networkmanager" "wheel"];
      packages = with pkgs; [
        firefox
        #  thunderbird
      ];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Nvidia
  services.xserver.videoDrivers = ["nvidia"];
  hardware.opengl.enable = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
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
