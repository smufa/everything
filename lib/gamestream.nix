{config, lib, pkgs, ...}:
lib.mkIf (config.everything.gamestream.enable) {
  security.wrappers.sunshine = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_admin+p";
      source = "${pkgs.sunshine}/bin/sunshine";
  };
  systemd.user.services.sunshine = let 
      sunshineOverride = pkgs.sunshine.override { cudaSupport = true; stdenv = pkgs.cudaPackages.backendStdenv; };
        in {
      enable = true;
      # this service is "wanted by" (see systemd man pages, or other tutorials) the system 
      # level that allows multiple users to login and interact with the machine non-graphically 
      # (see the Red Hat tutorial or Arch Linux Wiki for more information on what each target means) 
      # this is the "node" in the systemd dependency graph that will run the service
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      # systemd service unit declarations involve specifying dependencies and order of execution
      # of systemd nodes; here we are saying that we want our service to start after the network has 
      # set up (as our IRC client needs to relay over the network)
      description = "Sunshine self-hosted game stream host for Moonlight.";
      startLimitIntervalSec = 500;
      startLimitBurst = 5;

      # [Unit]
      # Description=Sunshine self-hosted game stream host for Moonlight.
      # StartLimitIntervalSec=500
      # StartLimitBurst=5

      # [Service]
      # ExecStart=<see table>
      # Restart=on-failure
      # RestartSec=5s
      # #Flatpak Only
      # #ExecStop=flatpak kill dev.lizardbyte.sunshine

      # [Install]
      # WantedBy=graphical-session.target
      
      serviceConfig = {
        ExecStart = ''nvidia-offload ${sunshineOverride}/bin/sunshine''; 
        Restart = "on-failure";
        RestartSec = "5s";
      };
   };
   environment.systemPackages = [ pkgs.sunshine pkgs.cudaPackages.cudatoolkit ];
 
   services.udev.extraRules = ''
     KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
   '';
}
