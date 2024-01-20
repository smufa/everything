{pkgs, home}:
{ options, config, lib, ... }:
with lib;
{
  options.everything = {
    gnome = {
      enable = mkEnableOption (mdDoc
      "Whether to enable gnome with modifications.");
      
    };
    space-optimization.enable = mkEnableOption 
    (mdDoc "Whether to enable nix space optimizations.");

    slo-locale.enable = mkEnableOption 
    (mdDoc "Whether to enable my prefered locale.");

    bootloader.enable = mkEnableOption 
    (mdDoc "Whether to enable systemd boot.");

    intel-hardware-acceleration.enable = mkEnableOption 
    (mdDoc "Whether to enable systemd boot.");

    nvidia-hardware-acceleration.enable = mkEnableOption 
    (mdDoc "Whether to enable systemd boot.");

    mdns.enable = mkEnableOption 
    (mdDoc "Whether to enable mds with avahi.");

    vpn = {
      enable = mkEnableOption 
      (mdDoc "Whether to enable vpn connection to siska.");
      private-key = mkOption {
        type = types.path;
        default = /home/enei/wireguard-keys/private;
        example = /etc/wireguard/private;
        description = ''
          Location of your wireguard privatekey.
        '';
      };
      address = mkOption {
        type = types.str;
        example = "10.1.1.100/24";
        description = ''
          Desired address on vpn.
        '';
      };
    };

    beep.enable = mkEnableOption 
    (mdDoc "Whether to enable PC speaker and install beep. WIP");

    podman = {
      enable = mkEnableOption 
      (mdDoc "Whether to enable container support with podman.");
      distrobox.enable = mkEnableOption 
      (mdDoc "Whether to enable distrobox and xhost. WIP");
    };
    
    users = mkOption {
      description = "User settings";
      type = types.attrsOf (types.submodule {
        options = {
          admin = mkOption {
            type = types.bool;
          };
          shell = mkOption {
            type = types.package;
            default = pkgs.bash;
          };
        };
      });
    };
  };
  
  imports = [ 
              ./lib/gnome.nix 
              ./lib/space-optimization.nix
              ./lib/locale.nix
              ./lib/boot.nix
              ./lib/intel-accel.nix
              ./lib/nvidia-accel.nix
              ./lib/vpn-client.nix
              ./lib/beep.nix
              ./lib/virtualisation.nix
              ./lib/users.nix 
              ./lib/mdns.nix
            ];
}
