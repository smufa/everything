{config, lib, pkgs, ...}:
lib.mkIf (config.everything.nvidia-hardware-acceleration.enable) {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Nvidia
  # Make sure opengl is enabled
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      libva1
      libvdpau-va-gl
      vaapiVdpau
    ];
  };

  # Tell Xorg to use the nvidia driver (also valid for Wayland)
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is needed for most Wayland compositors
    modesetting.enable = true;
    # Use the open source version of the kernel module
    # Only available on driver 515.43.04+
    open = false;
    # Enable the nvidia settings menu
    nvidiaSettings = true;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable = true;    
  };

  environment.systemPackages = [
    pkgs.cudaPackages.cudatoolkit
  ];
  # environment.systemPackages = let
  #   nvidia-video-sdk = 
  #     pkgs.stdenv.mkDerivation {
  #       pname = "nvidia-video-sdk";
  #       version = "12.1.14";

  #       # src = pkgs.fetchzip {
  #       #   url = "file:///home/enei/.config/everything/blobs/Video_Codec_SDK_12.1.14.zip";
  #       #   hash = "sha256-RzrPOAiQgbnJOvynm2oCH3K5fmXEfoHAnIlUtF/8AvI=";
  #       # };
  #       src = ../blobs/Video_Codec_SDK_12.1.14.zip;

  #       nativeBuildInputs = [ pkgs.unzip ];

  #       # We only need the header files. The library files are
  #       # in the nvidia_x11 driver.
  #       installPhase = ''
  #         # ls
  #         # echo --------
  #         # ls ..
  #         # unzip Video_Codec_SDK_12.1.14.zip
  #         mkdir -p -v $out/include
  #         ls Video_Codec_SDK_12.1.14/Samples/common/inc
  #         cp -R Video_Codec_SDK_12.1.14/Samples/common/inc/* $out/include
  #       '';

  #       meta = with lib; {
  #         description = "The NVIDIA Video Codec SDK";
  #         homepage = "https://developer.nvidia.com/nvidia-video-codec-sdk";
  #         license = licenses.unfree;
  #       };
  #     };
  # in  [
  #   nvidia-video-sdk
  # ];
}
