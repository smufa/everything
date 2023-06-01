{
  config,
  pkgs,
  lib,
  ...
}: let
  hostname = "malina";
in {
  imports = ["${fetchTarball "https://github.com/NixOS/nixos-hardware/archive/936e4649098d6a5e0762058cb7687be1b2d90550.tar.gz"}/raspberry-pi/4"];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };

  networking = {
    hostName = hostname;
    wireless = {
      enable = true;
      networks.LANdalf.psk = "INNBOX3130305000979";
      interfaces = ["wlan0"];
    };
    interfaces = {
      end0 = {
        ipv4.addresses = [
          {
            address = "84.255.199.103";
            prefixLength = 18;
          }
        ];
      };
      wlan0 = {
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

  environment.systemPackages = with pkgs; [neovim];

  services.openssh.enable = true;

  users = {
    mutableUsers = true;
    groups = {
      cool = {};
    };
    users = {
      nginx = {
        extraGroups = ["cool"];
      };
      enei = {
        isNormalUser = true;
        password = "temp";
        extraGroups = ["wheel" "cool"];
      };
      tina = {
        isNormalUser = true;
        password = "temp";
        extraGroups = ["wheel" "cool"];
      };
      lan = {
        isNormalUser = true;
        password = "temp";
        extraGroups = ["cool"];
      };
      nina = {
        isNormalUser = true;
        password = "temp";
        extraGroups = [];
      };
      katja = {
        isNormalUser = true;
        password = "temp";
        extraGroups = [];
      };
    };
  };

  # Enable GPU acceleration
  hardware.raspberry-pi."4".fkms-3d.enable = true;

  # Firewall
  networking.firewall.enable = false;

  services.nginx.enable = true;
  services.nginx.virtualHosts = {
    "zaanimivo.xyz" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www";
    };
    # "enei.zaanimivo.xyz" = {
    #   forceSSL = true;
    #   enableACME = true;
    #   root = "/home/enei/public";
    # };
  };

  security.acme = {
    acceptTerms = true;
    certs = {
      # "enei.zaanimivo.xyz".email = "enei.sluga@gmail.com";
      "zaanimivo.xyz".email = "enei.sluga@gmail.com";
    };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "23.05";
}
