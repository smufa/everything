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
    # vpn = {
    #   enable = true;
    #   address = "10.1.1.3/24";
    # };
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

  # Extend life of SSD
  services.fstrim.enable = true;
  services.fwupd.enable = true;

  fileSystems."/hdd" = {
    device = "/dev/disk/by-label/hard";
    fsType = "btrfs";
    # options = ["subvol=@"];
  };
  services.btrfs.autoScrub.enable = true;

  networking.hostName = "kista"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # networking.networkmanager.unmanaged = ["enp6s0" "wlp7s0"];
  #           address = "84.255.199.103";
  networking.wireguard.interfaces = {
    mesh = {
      listenPort = 23568;
      ips = ["10.2.2.2/24"];

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

  # virtualisation.oci-containers.backend = "podman";
  # virtualisation.oci-containers.containers = {
  #   notebook = {
  #     hostname = "notebook";
  #     image = "library/fedora";
  # #     # image = "jupyter/scipy-notebook";
  # #     # extraOptions = ["--ip=0.0.0.0" "--NotebookApp.password=sha1:137775e93d29:ba64d3b78e089f0f779167242ddb080a05c42a84"];
  # #     # entrypoint = "/bin/bash";
  #     autoStart = true;
  #     ports = [ "127.0.0.1:8888:8888" ];
  #   };
  # };

  # containers.notebook = let 
  #   python = (pkgs.python311.withPackages (ps: with ps; [
  #               numpy
  #               pandas
  #               scipy
  #               matplotlib
  #               networkx
  #               ipykernel
  #               python-lsp-server
  #               jupyterlab
  #               jupyterlab-lsp
  #               jupyterlab-widgets
  #               jupyterlab-server
  #               jupyter-collaboration
  #               # jupyterlab-git
  #               ipywidgets
  #             ])); 
  #   in {
  #   autoStart = true;
  #   config = { config, pkgs, lib, ... }: {

  #     systemd.services.notebook = {
  #        wantedBy = [ "multi-user.target" ];
  #        after = [ "network.target" ];
  #        description = "Collaborative Notebook.";
  #        serviceConfig = {
  #          # the command to execute when the service starts up 
  #          ExecStart = ''${python}/bin/python -m jupyterlab --ip=0.0.0.0 --notebook-dir=/home/ina/ --no-browser --NotebookApp.password=sha1:137775e93d29:ba64d3b78e089f0f779167242ddb080a05c42a84''; 
  #          User = "ina";
  #          # Group = "ina";
  #          Restart = "always";
  #          RestartSec = "10";
  #        };
  #     };
  #     # environment.systemPackages = [ python ];
  #     users.users.ina = {
  #       isNormalUser = true;
  #       packages = [ python ];
  #     };

  #     system.stateVersion = "23.11";

  #     networking = {
  #       firewall = {
  #         enable = true;
  #         allowedTCPPorts = [ 8888 ];
  #       };
  #       # Use systemd-resolved inside the container
  #       # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
  #       useHostResolvConf = lib.mkForce false;
  #     };
  #     services.resolved.enable = true;

  #   };
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
