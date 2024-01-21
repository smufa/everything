{config, lib, pkgs, home, ...}:
let 
  names = lib.attrsets.mapAttrsToList (name: value: name) config.everything.users;
  foldAttr = lib.lists.foldr lib.attrsets.recursiveUpdate {};
in {
  users.users = foldAttr (lib.lists.forEach names (user: {
    ${user} = {
      isNormalUser = true;
      description = user;
      extraGroups = lib.mkMerge [
        (lib.mkIf config.everything.users.${user}.admin 
            ["networkmanager" "wheel" "uinput" "input" "plugdev"])
      ];

      shell = config.everything.users.${user}.shell;
    };
  }));
  nix.settings.trusted-users = ["root" "enei" ];
  # home.nixosModules.home-manager
  # {
  #   home-manager.useGlobalPkgs = true;
  #   home-manager.useUserPackages = true;
  #   home-manager.users.enei = import ./lib/home.nix {
  #     pkgs = builtins.getAttr "x86_64-linux" nixpkgs.legacyPackages;
  #     hx-theme = "pop-dark";
  #   };

  #   # Optionally, use home-manager.extraSpecialArgs to pass
  #   # arguments to home.nix
  # }

}
