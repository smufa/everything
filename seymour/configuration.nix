# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  everything = {
    space-optimization.enable = true; 
    slo-locale.enable = true;
    bootloader.enable = true;
    intel-hardware-acceleration.enable = true;
    podman.enable = true;
    mdns.enable = true;
    users.enei = {
      admin = true;
      shell = pkgs.fish;
    };
    users.tina = {
      admin = true;
      shell = pkgs.fish;
    };
  };

  # boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

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


  networking.wireguard.interfaces = {
    mesh = {
      listenPort = 23568;
      ips = ["10.2.2.1/24"];

      privateKeyFile = "/home/enei/.wireguard-keys/private";
    };
  };
  
  services.wgautomesh = {
    enable = true;
    openFirewall = true;
    enablePersistence = true;
    enableGossipEncryption = true;
    gossipSecretFile = "/home/enei/.wireguard-keys/gossip";
    settings = {
      interface = "mesh";
      lan_discovery = true;
      peers = [
        {
          pubkey = "48pSfQjFSFzNQ/aeLQQU39g6RzqId/fvp8Z82GzCZ0A=";
          address = "10.2.2.2";
          endpoint = "192.168.64.140:23568";
        }

        {
          pubkey = "KwVT9IJWpvU/qg0LAe23BcLw4IJ8efeJS7xJ0ijhkxQ=";
          address = "10.2.2.3";
        }

        {
          pubkey = "Pe2KUyql4rS459LSjWCLImVpWxkwS1jjXmRyw9IZSHw=";
          address = "10.2.2.4";
          endpoint = "zaanimivo.xyz:23568";
        }
      ];
    };
  };

  services.logind.lidSwitch = "ignore";

  programs.fish.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    zellij
    git
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
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
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
  programs.ssh.startAgent = true;

  # Open ports in the firewall.
  networking.firewall.interfaces.enp3s0f2.allowedTCPPorts = [ 80 443 23568 ];
  networking.firewall.interfaces.enp3s0f2.allowedUDPPorts = [ 80 443 23568 ];
  networking.firewall.interfaces.lo.allowedTCPPortRanges = [{from=0; to=65535;}];
  networking.firewall.interfaces.lo.allowedUDPPortRanges = [{from=0; to=65535;}];
  networking.firewall.interfaces.wlp2s0.allowedTCPPortRanges = [{from=0; to=65535;}];
  networking.firewall.interfaces.wlp2s0.allowedUDPPortRanges = [{from=0; to=65535;}];
  networking.firewall.interfaces.wg0.allowedTCPPortRanges = [{from=0; to=65535;}];
  networking.firewall.interfaces.wg0.allowedUDPPortRanges = [{from=0; to=65535;}];
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
      root = "/page/enei";
    };
    "zelje.zaanimivo.xyz" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        root = "/var/www/bubu/";
        extraConfig = ''
          try_files $uri $uri/ /index.html =404;
        '';
      };
    };
    "karaoke.zaanimivo.xyz" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        root = "/var/www/bububu/";
        extraConfig = ''
          try_files $uri $uri/ /index.html =404;
        '';
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    certs = {
      "enei.zaanimivo.xyz".email = "enei.sluga@gmail.com";
      "zaanimivo.xyz".email = "enei.sluga@gmail.com";
      "zelje.zaanimivo.xyz".email = "enei.sluga@gmail.com";
      "karaoke.zaanimivo.xyz".email = "enei.sluga@gmail.com";
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
