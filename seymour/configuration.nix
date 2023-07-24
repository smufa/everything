# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../lib/space-optimization.nix
      ../lib/locale.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "seymour"; # Define your hostname.
  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking wlp2s0
  # networking.networkmanager.enable = true;
  networking = {
    wireless = {
      enable = true;
      networks.LANdalf.psk = "INNBOX3130305000979";
      interfaces = ["wlp2s0"];
    };
    interfaces = {
      enp3s0f2 = {
        ipv4.addresses = [
          {
            address = "84.255.199.103";
            prefixLength = 18;
          }
        ];
      };
      wlp2s0 = {
        ipv4.addresses = [
          {
            address = "192.168.64.69";
            prefixLength = 24;
          }
        ];
        ipv4.routes = [
          {
            address = "192.168.64.0";
            prefixLength = 24;
            via = "192.168.64.1";
          }
        ];
      };
    };
    defaultGateway = "84.255.192.1";
    nameservers = ["84.255.209.79"];
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  services.logind.lidSwitch = "ignore";

  programs.fish.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      enei = {
        isNormalUser = true;
        description = "najaci tip";
        extraGroups = [ "networkmanager" "wheel" ];
        shell = pkgs.fish;
      };
      tina = {
        isNormalUser = true;
        description = "najaci tipica";
        extraGroups = [ "networkmanager" "wheel" ];
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    zellij
    git
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

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
  programs.ssh.startAgent = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ 80 443 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  services.nginx.enable = true;
  services.nginx.virtualHosts = {
    "main" = {
      serverName = "zaanimivo.xyz";
      forceSSL = true;
      enableACME = true;
      root = "/var/www";
    };
    "enei" = {
      serverName = "enei.zaanimivo.xyz";
      forceSSL = true;
      enableACME = true;
      root = "/home/enei/public";
    };
  };

  security.acme = {
    acceptTerms = true;
    certs = {
      "enei.zaanimivo.xyz".email = "enei.sluga@gmail.com";
      "zaanimivo.xyz".email = "enei.sluga@gmail.com";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
